#ifndef  KUBOT_TRANSPORT_SERIAL2_H_
#define KUBOT_TRANSPORT_SERIAL2_H_

#include "transport.h"

class Serial_transport2 : public Transport 
{
	public:
		Serial_transport2 (std::string url, int32_t baudrate);
			~Serial_transport2();
		bool init();
		Buffer read();

		void write(Buffer &data);

    	void set_timeout(int t);
    	bool is_timeout();
	private:
		void mainRun();
	
		unsigned long m_timeout_us;
	
		bool m_timeoutFlag;
    	int m_fd;
		std::string m_port;
		int32_t m_baudrate;
};


#endif 

//  KUBOT_TRANSPORT_SERIAL2_H_
