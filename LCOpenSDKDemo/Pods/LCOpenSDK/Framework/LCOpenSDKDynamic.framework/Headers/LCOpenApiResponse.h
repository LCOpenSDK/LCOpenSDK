//
//  BaseResponse.hpp
//  LCOpenApiClient_C++
//
//  Created by mac318340418 on 17/1/5.
//  Copyright © 2017年 bzy. All rights reserved.
//

#ifndef _LCOpenApiResponse_H_
#define _LCOpenApiResponse_H_

#include <iostream>
#include <string>

using namespace std;
namespace Dahua {
namespace LCOpenApi {

    class LCOpenApiResponse {
    public:
        virtual int parse() = 0;

    public:
        string headers;
        int code;
        string desc;
        string date;
        unsigned long content_length;
        string content;

        string id;
        string ret_code;
        string ret_msg;
    };
    
    class LCOpenApiBase {};
}
}

#endif /* BaseResponse_hpp */
