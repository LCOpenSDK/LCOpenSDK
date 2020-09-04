//
//  Header.h
//  LCOpenApiClient_C++
//
//  Created by mac318340418 on 17/1/6.
//  Copyright © 2017年 bzy. All rights reserved.
//

#ifndef _LCOpen_Api_Define_H_
#define _LCOpen_Api_Define_H_

//namespace Dahua {
//namespace LCOpenApi {
#ifdef WIN32
typedef long long int64;
#else
#include <inttypes.h>
typedef int64_t int64;
#endif

#define HTTP_OK						200
#define HTTP_BAD_REQUEST			400
#define HTTP_UNAUTHORIZED			401
#define HTTP_FORBIDDEN				403
#define HTTP_NOT_FOUND				404
#define HTTP_PRECONDITION_FAILED	412

#include <vector>
namespace Dahua {
namespace LCOpenApi {
    template <class T>
    class LCOpenApiVector {
    public:
        void addMember(T& member)
        {
            T* newMember = new T(member);
            members.push_back(newMember);
        }

        T* getLastMember()
        {
            return members.back();
        }

        void removeLastMember()
        {
            members.pop_back();
        }

        bool isEmpty()
        {
            return members.empty();
        }

        unsigned long size()
        {
            return members.size();
        }

        T* at(unsigned long index)
        {
            return members.at(index);
        }

    private:
        std::vector<T*> members;
    };
}
}


#endif /* Header_h */
