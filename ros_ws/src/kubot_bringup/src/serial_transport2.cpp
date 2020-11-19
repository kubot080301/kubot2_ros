#include "serial_transport2.h"
#include <ros/ros.h>

Serial_transport2::Serial_transport2(std::string port, int32_t buadrate) : m_port(port), m_buadrate(buadrate), m_timeout_us(1000*1000)
{
    m_timeoutFlag = false;
}

Serial_transport2::~Serial_transport2()
{
    if (m_fd)
        close(m_fd);
}

bool Serial_transport2::init()
{
    ROS_INFO("open %s %d", m_port.c_str(), m_buadrate);
    m_fd = ::open(m_port.c_str(), O_RDWR | O_NDELAY);
    if(m_fd < 0) {
        ROS_ERROR("open %s err", m_port.c_str());
        return false;
    }

    tcflush(m_fd, TCIOFLUSH);

    int n = fcntl(m_fd, F_GETFL, 0);
    fcntl(m_fd, F_SETFL, n & ~O_NDELAY);

    struct termios opt;
    tcgetattr(m_fd, &opt);

    if (m_buadrate == 921600) {
        cfsetispeed(&opt, B921600);
        cfsetospeed(&opt, B921600);
    } else if (m_buadrate == 1500000) {
        cfsetispeed(&opt, B1500000);
        cfsetospeed(&opt, B1500000);
    } else { //if (m_buadrate == 115200) 
        cfsetispeed(&opt, B115200);
        cfsetospeed(&opt, B115200);
    } 

    opt.c_cflag &= ~CSIZE | CS8;
    opt.c_cflag |= (CLOCAL | CREAD);

    opt.c_cflag &= ~(PARENB|PARODD);
    opt.c_cflag &= ~CSTOPB;

    opt.c_cflag &= ~CRTSCTS;

    opt.c_iflag = IGNBRK;
    opt.c_iflag &= ~(IXON | IXOFF | IXANY);

    opt.c_lflag = 0;
    opt.c_oflag = 0;

    opt.c_cc[VMIN] = 0;
    opt.c_cc[VTIME] = 0;

    if((tcsetattr(m_fd, TCSANOW, &opt)) != 0)
        return false;

    int mcs = 0;
    ioctl(m_fd, TIOCMGET, &mcs);
    mcs |= TIOCM_RTS;
    ioctl(m_fd, TIOCMGET, &mcs);
    
    if (tcgetattr(m_fd, &opt)!=0) {
        ROS_ERROR("tcsetattr failed");
    }

    opt.c_cflag &= ~CRTSCTS;

    if (tcsetattr(m_fd, TCSANOW, &opt)!=0) {
        ROS_ERROR("tcsetattr failed");
    }

    return true;
}

Buffer Serial_transport2::read()
{
    Buffer data;

    fd_set rfds;
    FD_ZERO(&rfds);
    FD_SET(m_fd, &rfds);
    struct timeval tm;
    tm.tv_sec = 0;
    tm.tv_usec=m_timeout_us;

    int retval = select(m_fd + 1, &rfds, NULL, NULL, &tm);
    if (retval == -1 && errno == EINTR){
        ROS_ERROR("select failure");
        return data;
    }
    if (retval < 0) {
        ROS_ERROR("select failure");
        return data;
    }

    if (!FD_ISSET(m_fd, &rfds)) {
        m_timeoutFlag = true;
        return data;
    }

    char buffer[256] = {0};
    int len = ::read(m_fd, buffer, sizeof(buffer));
    if (len > 0){
        // printf("recv: ");
        for (int i=0;i<len;i++) {
            data.push_back(buffer[i]);
            // printf("%02x ", (unsigned char)buffer[i]);
        }
        // printf("\r\n");
    } else
    {
        ROS_INFO("read err %d", len);
    }
    
    return data;
}

void Serial_transport2::write(Buffer &data)
{
    // printf("send: ");
    // for (int i=0;i<data.size();i++) {
    //     printf("%02x ", (unsigned char)data[i]);
    // }
    // printf("\r\n");
    ::write(m_fd, data.data(), data.size());
}

void Serial_transport2::set_timeout(int t){
    m_timeout_us = t*1000;
}

bool Serial_transport2::is_timeout(){
    bool timeout = m_timeoutFlag;
    m_timeoutFlag = false;
    return timeout;
}
