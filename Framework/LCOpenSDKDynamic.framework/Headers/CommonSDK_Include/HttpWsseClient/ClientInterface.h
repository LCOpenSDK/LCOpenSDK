#pragma once
#include <string>

namespace Dahua {
namespace LCCommon {

class ClientInterface
{
public:
    ClientInterface(const char *host, int port, bool withSSL = false);
    ~ClientInterface(void);

    bool upgradeDevice(const char *deviceSN, const char *userName, const char *password, char *responseBuf, int &bufLen);
    bool queryUpgradeProcess(const char *deviceSN, const char *userName, const char *password, char *responseBuf, int &bufLen);

private:
    std::string m_host;
    int         m_port;
    bool        m_withSSL;
};

} //LCCommon
} //Dahua

