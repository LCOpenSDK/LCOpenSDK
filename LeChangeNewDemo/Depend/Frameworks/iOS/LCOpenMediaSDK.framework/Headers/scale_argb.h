/*
 *  Copyright 2012 The LibYuv Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS. All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#ifndef INCLUDE_LIBYUV_SCALE_ARGB_H_
#define INCLUDE_LIBYUV_SCALE_ARGB_H_

#include <LCOpenMediaSDK/basic_types.h>
#include <LCOpenMediaSDK/scale.h>  // For FilterMode

#ifdef __cplusplus
namespace libyuv {
extern "C" {
#endif

LIBYUV_API
int ARGBScale(const uint8* src_argb,
              int src_stride_argb,
              int src_width,
              int src_height,
              uint8* dst_argb,
              int dst_stride_argb,
              int dst_width,
              int dst_height,
              enum FilterMode filtering);

// Clipped scale takes destination rectangle coordinates for clip values.
LIBYUV_API
int ARGBScaleClip(const uint8* src_argb,
                  int src_stride_argb,
                  int src_width,
                  int src_height,
                  uint8* dst_argb,
                  int dst_stride_argb,
                  int dst_width,
                  int dst_height,
                  int clip_x,
                  int clip_y,
                  int clip_width,
                  int clip_height,
                  enum FilterMode filtering);

// Scale with YUV conversion to ARGB and clipping.
LIBYUV_API
int YUVToARGBScaleClip(const uint8* src_y,
                       int src_stride_y,
                       const uint8* src_u,
                       int src_stride_u,
                       const uint8* src_v,
                       int src_stride_v,
                       uint32 src_fourcc,
                       int src_width,
                       int src_height,
                       uint8* dst_argb,
                       int dst_stride_argb,
                       uint32 dst_fourcc,
                       int dst_width,
                       int dst_height,
                       int clip_x,
                       int clip_y,
                       int clip_width,
                       int clip_height,
                       enum FilterMode filtering);

#ifdef __cplusplus
}  // extern "C"
}  // namespace libyuv
#endif

#endif  // INCLUDE_LIBYUV_SCALE_ARGB_H_
