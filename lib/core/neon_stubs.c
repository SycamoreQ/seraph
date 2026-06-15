#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <arm_neon.h>

CAMLprim value caml_seraph_vld1q_f32(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const float *ptr = (const float *)(Bytes_val(buf) + Int_val(off));
  float32x4_t v = vld1q_f32(ptr);
  result = caml_alloc_string(16);
  vst1q_f32((float *)Bytes_val(result), v);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld1_f32(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const float *ptr = (const float *)(Bytes_val(buf) + Int_val(off));
  float32x2_t v = vld1_f32(ptr);
  result = caml_alloc_string(8);
  vst1_f32((float *)Bytes_val(result), v);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld1q_f64(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const double *ptr = (const double *)(Bytes_val(buf) + Int_val(off));
  float64x2_t v = vld1q_f64(ptr);
  result = caml_alloc_string(16);
  vst1q_f64((double *)Bytes_val(result), v);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld1_f64(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const double *ptr = (const double *)(Bytes_val(buf) + Int_val(off));
  float64x1_t v = vld1_f64(ptr);
  result = caml_alloc_string(8);
  vst1_f64((double *)Bytes_val(result), v);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld1q_s8(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const int8_t *ptr = (const int8_t *)(Bytes_val(buf) + Int_val(off));
  int8x16_t v = vld1q_s8(ptr);
  result = caml_alloc_string(16);
  vst1q_s8((int8_t *)Bytes_val(result), v);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld1_s8(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const int8_t *ptr = (const int8_t *)(Bytes_val(buf) + Int_val(off));
  int8x8_t v = vld1_s8(ptr);
  result = caml_alloc_string(8);
  vst1_s8((int8_t *)Bytes_val(result), v);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld1q_s16(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const int16_t *ptr = (const int16_t *)(Bytes_val(buf) + Int_val(off));
  int16x8_t v = vld1q_s16(ptr);
  result = caml_alloc_string(16);
  vst1q_s16((int16_t *)Bytes_val(result), v);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld1_s16(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const int16_t *ptr = (const int16_t *)(Bytes_val(buf) + Int_val(off));
  int16x4_t v = vld1_s16(ptr);
  result = caml_alloc_string(8);
  vst1_s16((int16_t *)Bytes_val(result), v);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld1q_s32(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const int32_t *ptr = (const int32_t *)(Bytes_val(buf) + Int_val(off));
  int32x4_t v = vld1q_s32(ptr);
  result = caml_alloc_string(16);
  vst1q_s32((int32_t *)Bytes_val(result), v);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld1_s32(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const int32_t *ptr = (const int32_t *)(Bytes_val(buf) + Int_val(off));
  int32x2_t v = vld1_s32(ptr);
  result = caml_alloc_string(8);
  vst1_s32((int32_t *)Bytes_val(result), v);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld1q_u8(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const uint8_t *ptr = (const uint8_t *)(Bytes_val(buf) + Int_val(off));
  uint8x16_t v = vld1q_u8(ptr);
  result = caml_alloc_string(16);
  vst1q_u8((uint8_t *)Bytes_val(result), v);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld1_u8(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const uint8_t *ptr = (const uint8_t *)(Bytes_val(buf) + Int_val(off));
  uint8x8_t v = vld1_u8(ptr);
  result = caml_alloc_string(8);
  vst1_u8((uint8_t *)Bytes_val(result), v);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld1q_u16(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const uint16_t *ptr = (const uint16_t *)(Bytes_val(buf) + Int_val(off));
  uint16x8_t v = vld1q_u16(ptr);
  result = caml_alloc_string(16);
  vst1q_u16((uint16_t *)Bytes_val(result), v);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld1_u16(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const uint16_t *ptr = (const uint16_t *)(Bytes_val(buf) + Int_val(off));
  uint16x4_t v = vld1_u16(ptr);
  result = caml_alloc_string(8);
  vst1_u16((uint16_t *)Bytes_val(result), v);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld1q_u32(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const uint32_t *ptr = (const uint32_t *)(Bytes_val(buf) + Int_val(off));
  uint32x4_t v = vld1q_u32(ptr);
  result = caml_alloc_string(16);
  vst1q_u32((uint32_t *)Bytes_val(result), v);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld1_u32(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  const uint32_t *ptr = (const uint32_t *)(Bytes_val(buf) + Int_val(off));
  uint32x2_t v = vld1_u32(ptr);
  result = caml_alloc_string(8);
  vst1_u32((uint32_t *)Bytes_val(result), v);
  CAMLreturn(result);
}

/* ------------------------------------------------------------------ */
/* vst1 — unit stride stores                                           */
/* ------------------------------------------------------------------ */

CAMLprim value caml_seraph_vst1q_f32(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  float32x4_t v = vld1q_f32((const float *)Bytes_val(vec));
  vst1q_f32((float *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst1_f32(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  float32x2_t v = vld1_f32((const float *)Bytes_val(vec));
  vst1_f32((float *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst1q_f64(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  float64x2_t v = vld1q_f64((const double *)Bytes_val(vec));
  vst1q_f64((double *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst1_f64(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  float64x1_t v = vld1_f64((const double *)Bytes_val(vec));
  vst1_f64((double *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst1q_s8(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  int8x16_t v = vld1q_s8((const int8_t *)Bytes_val(vec));
  vst1q_s8((int8_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst1_s8(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  int8x8_t v = vld1_s8((const int8_t *)Bytes_val(vec));
  vst1_s8((int8_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst1q_s16(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  int16x8_t v = vld1q_s16((const int16_t *)Bytes_val(vec));
  vst1q_s16((int16_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst1_s16(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  int16x4_t v = vld1_s16((const int16_t *)Bytes_val(vec));
  vst1_s16((int16_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst1q_s32(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  int32x4_t v = vld1q_s32((const int32_t *)Bytes_val(vec));
  vst1q_s32((int32_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst1_s32(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  int32x2_t v = vld1_s32((const int32_t *)Bytes_val(vec));
  vst1_s32((int32_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst1q_u8(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  uint8x16_t v = vld1q_u8((const uint8_t *)Bytes_val(vec));
  vst1q_u8((uint8_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst1_u8(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  uint8x8_t v = vld1_u8((const uint8_t *)Bytes_val(vec));
  vst1_u8((uint8_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst1q_u16(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  uint16x8_t v = vld1q_u16((const uint16_t *)Bytes_val(vec));
  vst1q_u16((uint16_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst1_u16(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  uint16x4_t v = vld1_u16((const uint16_t *)Bytes_val(vec));
  vst1_u16((uint16_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst1q_u32(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  uint32x4_t v = vld1q_u32((const uint32_t *)Bytes_val(vec));
  vst1q_u32((uint32_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst1_u32(value buf, value off, value vec)
{
  CAMLparam3(buf, off, vec);
  uint32x2_t v = vld1_u32((const uint32_t *)Bytes_val(vec));
  vst1_u32((uint32_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

/* ------------------------------------------------------------------ */
/* vld2 — interleaved 2-vector loads                                   */
/* vec2 is an OCaml record {val0: Bytes.t; val1: Bytes.t}             */
/* Field 0 = val0, Field 1 = val1                                     */
/* ------------------------------------------------------------------ */

CAMLprim value caml_seraph_vld2q_f32(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal3(result, v0, v1);
  const float *ptr = (const float *)(Bytes_val(buf) + Int_val(off));
  float32x4x2_t v = vld2q_f32(ptr);
  v0 = caml_alloc_string(16); vst1q_f32((float *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_f32((float *)Bytes_val(v1), v.val[1]);
  result = caml_alloc(2, 0);
  Store_field(result, 0, v0);
  Store_field(result, 1, v1);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld2_f32(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal3(result, v0, v1);
  const float *ptr = (const float *)(Bytes_val(buf) + Int_val(off));
  float32x2x2_t v = vld2_f32(ptr);
  v0 = caml_alloc_string(8); vst1_f32((float *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(8); vst1_f32((float *)Bytes_val(v1), v.val[1]);
  result = caml_alloc(2, 0);
  Store_field(result, 0, v0);
  Store_field(result, 1, v1);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld2q_s8(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal3(result, v0, v1);
  const int8_t *ptr = (const int8_t *)(Bytes_val(buf) + Int_val(off));
  int8x16x2_t v = vld2q_s8(ptr);
  v0 = caml_alloc_string(16); vst1q_s8((int8_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_s8((int8_t *)Bytes_val(v1), v.val[1]);
  result = caml_alloc(2, 0);
  Store_field(result, 0, v0);
  Store_field(result, 1, v1);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld2_s8(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal3(result, v0, v1);
  const int8_t *ptr = (const int8_t *)(Bytes_val(buf) + Int_val(off));
  int8x8x2_t v = vld2_s8(ptr);
  v0 = caml_alloc_string(8); vst1_s8((int8_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(8); vst1_s8((int8_t *)Bytes_val(v1), v.val[1]);
  result = caml_alloc(2, 0);
  Store_field(result, 0, v0);
  Store_field(result, 1, v1);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld2q_s16(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal3(result, v0, v1);
  const int16_t *ptr = (const int16_t *)(Bytes_val(buf) + Int_val(off));
  int16x8x2_t v = vld2q_s16(ptr);
  v0 = caml_alloc_string(16); vst1q_s16((int16_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_s16((int16_t *)Bytes_val(v1), v.val[1]);
  result = caml_alloc(2, 0);
  Store_field(result, 0, v0);
  Store_field(result, 1, v1);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld2_s16(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal3(result, v0, v1);
  const int16_t *ptr = (const int16_t *)(Bytes_val(buf) + Int_val(off));
  int16x4x2_t v = vld2_s16(ptr);
  v0 = caml_alloc_string(8); vst1_s16((int16_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(8); vst1_s16((int16_t *)Bytes_val(v1), v.val[1]);
  result = caml_alloc(2, 0);
  Store_field(result, 0, v0);
  Store_field(result, 1, v1);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld2q_s32(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal3(result, v0, v1);
  const int32_t *ptr = (const int32_t *)(Bytes_val(buf) + Int_val(off));
  int32x4x2_t v = vld2q_s32(ptr);
  v0 = caml_alloc_string(16); vst1q_s32((int32_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_s32((int32_t *)Bytes_val(v1), v.val[1]);
  result = caml_alloc(2, 0);
  Store_field(result, 0, v0);
  Store_field(result, 1, v1);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld2q_u8(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal3(result, v0, v1);
  const uint8_t *ptr = (const uint8_t *)(Bytes_val(buf) + Int_val(off));
  uint8x16x2_t v = vld2q_u8(ptr);
  v0 = caml_alloc_string(16); vst1q_u8((uint8_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_u8((uint8_t *)Bytes_val(v1), v.val[1]);
  result = caml_alloc(2, 0);
  Store_field(result, 0, v0);
  Store_field(result, 1, v1);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld2q_u16(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal3(result, v0, v1);
  const uint16_t *ptr = (const uint16_t *)(Bytes_val(buf) + Int_val(off));
  uint16x8x2_t v = vld2q_u16(ptr);
  v0 = caml_alloc_string(16); vst1q_u16((uint16_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_u16((uint16_t *)Bytes_val(v1), v.val[1]);
  result = caml_alloc(2, 0);
  Store_field(result, 0, v0);
  Store_field(result, 1, v1);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vld2q_u32(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal3(result, v0, v1);
  const uint32_t *ptr = (const uint32_t *)(Bytes_val(buf) + Int_val(off));
  uint32x4x2_t v = vld2q_u32(ptr);
  v0 = caml_alloc_string(16); vst1q_u32((uint32_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_u32((uint32_t *)Bytes_val(v1), v.val[1]);
  result = caml_alloc(2, 0);
  Store_field(result, 0, v0);
  Store_field(result, 1, v1);
  CAMLreturn(result);
}

/* ------------------------------------------------------------------ */
/* vst2 — interleaved 2-vector stores                                  */
/* ------------------------------------------------------------------ */

CAMLprim value caml_seraph_vst2q_f32(value buf, value off, value rec2)
{
  CAMLparam3(buf, off, rec2);
  float32x4x2_t v;
  v.val[0] = vld1q_f32((const float *)Bytes_val(Field(rec2, 0)));
  v.val[1] = vld1q_f32((const float *)Bytes_val(Field(rec2, 1)));
  vst2q_f32((float *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst2_f32(value buf, value off, value rec2)
{
  CAMLparam3(buf, off, rec2);
  float32x2x2_t v;
  v.val[0] = vld1_f32((const float *)Bytes_val(Field(rec2, 0)));
  v.val[1] = vld1_f32((const float *)Bytes_val(Field(rec2, 1)));
  vst2_f32((float *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst2q_s8(value buf, value off, value rec2)
{
  CAMLparam3(buf, off, rec2);
  int8x16x2_t v;
  v.val[0] = vld1q_s8((const int8_t *)Bytes_val(Field(rec2, 0)));
  v.val[1] = vld1q_s8((const int8_t *)Bytes_val(Field(rec2, 1)));
  vst2q_s8((int8_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst2_s8(value buf, value off, value rec2)
{
  CAMLparam3(buf, off, rec2);
  int8x8x2_t v;
  v.val[0] = vld1_s8((const int8_t *)Bytes_val(Field(rec2, 0)));
  v.val[1] = vld1_s8((const int8_t *)Bytes_val(Field(rec2, 1)));
  vst2_s8((int8_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst2q_s16(value buf, value off, value rec2)
{
  CAMLparam3(buf, off, rec2);
  int16x8x2_t v;
  v.val[0] = vld1q_s16((const int16_t *)Bytes_val(Field(rec2, 0)));
  v.val[1] = vld1q_s16((const int16_t *)Bytes_val(Field(rec2, 1)));
  vst2q_s16((int16_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst2_s16(value buf, value off, value rec2)
{
  CAMLparam3(buf, off, rec2);
  int16x4x2_t v;
  v.val[0] = vld1_s16((const int16_t *)Bytes_val(Field(rec2, 0)));
  v.val[1] = vld1_s16((const int16_t *)Bytes_val(Field(rec2, 1)));
  vst2_s16((int16_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst2q_s32(value buf, value off, value rec2)
{
  CAMLparam3(buf, off, rec2);
  int32x4x2_t v;
  v.val[0] = vld1q_s32((const int32_t *)Bytes_val(Field(rec2, 0)));
  v.val[1] = vld1q_s32((const int32_t *)Bytes_val(Field(rec2, 1)));
  vst2q_s32((int32_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst2q_u8(value buf, value off, value rec2)
{
  CAMLparam3(buf, off, rec2);
  uint8x16x2_t v;
  v.val[0] = vld1q_u8((const uint8_t *)Bytes_val(Field(rec2, 0)));
  v.val[1] = vld1q_u8((const uint8_t *)Bytes_val(Field(rec2, 1)));
  vst2q_u8((uint8_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst2q_u16(value buf, value off, value rec2)
{
  CAMLparam3(buf, off, rec2);
  uint16x8x2_t v;
  v.val[0] = vld1q_u16((const uint16_t *)Bytes_val(Field(rec2, 0)));
  v.val[1] = vld1q_u16((const uint16_t *)Bytes_val(Field(rec2, 1)));
  vst2q_u16((uint16_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vst2q_u32(value buf, value off, value rec2)
{
  CAMLparam3(buf, off, rec2);
  uint32x4x2_t v;
  v.val[0] = vld1q_u32((const uint32_t *)Bytes_val(Field(rec2, 0)));
  v.val[1] = vld1q_u32((const uint32_t *)Bytes_val(Field(rec2, 1)));
  vst2q_u32((uint32_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

/* ------------------------------------------------------------------ */
/* vld3 / vst3                                                         */
/* ------------------------------------------------------------------ */

CAMLprim value caml_seraph_vld3q_f32(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal4(result, v0, v1, v2);
  const float *ptr = (const float *)(Bytes_val(buf) + Int_val(off));
  float32x4x3_t v = vld3q_f32(ptr);
  v0 = caml_alloc_string(16); vst1q_f32((float *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_f32((float *)Bytes_val(v1), v.val[1]);
  v2 = caml_alloc_string(16); vst1q_f32((float *)Bytes_val(v2), v.val[2]);
  result = caml_alloc(3, 0);
  Store_field(result, 0, v0);
  Store_field(result, 1, v1);
  Store_field(result, 2, v2);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vst3q_f32(value buf, value off, value rec3)
{
  CAMLparam3(buf, off, rec3);
  float32x4x3_t v;
  v.val[0] = vld1q_f32((const float *)Bytes_val(Field(rec3, 0)));
  v.val[1] = vld1q_f32((const float *)Bytes_val(Field(rec3, 1)));
  v.val[2] = vld1q_f32((const float *)Bytes_val(Field(rec3, 2)));
  vst3q_f32((float *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vld3q_s8(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal4(result, v0, v1, v2);
  const int8_t *ptr = (const int8_t *)(Bytes_val(buf) + Int_val(off));
  int8x16x3_t v = vld3q_s8(ptr);
  v0 = caml_alloc_string(16); vst1q_s8((int8_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_s8((int8_t *)Bytes_val(v1), v.val[1]);
  v2 = caml_alloc_string(16); vst1q_s8((int8_t *)Bytes_val(v2), v.val[2]);
  result = caml_alloc(3, 0);
  Store_field(result, 0, v0); Store_field(result, 1, v1); Store_field(result, 2, v2);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vst3q_s8(value buf, value off, value rec3)
{
  CAMLparam3(buf, off, rec3);
  int8x16x3_t v;
  v.val[0] = vld1q_s8((const int8_t *)Bytes_val(Field(rec3, 0)));
  v.val[1] = vld1q_s8((const int8_t *)Bytes_val(Field(rec3, 1)));
  v.val[2] = vld1q_s8((const int8_t *)Bytes_val(Field(rec3, 2)));
  vst3q_s8((int8_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vld3q_u8(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal4(result, v0, v1, v2);
  const uint8_t *ptr = (const uint8_t *)(Bytes_val(buf) + Int_val(off));
  uint8x16x3_t v = vld3q_u8(ptr);
  v0 = caml_alloc_string(16); vst1q_u8((uint8_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_u8((uint8_t *)Bytes_val(v1), v.val[1]);
  v2 = caml_alloc_string(16); vst1q_u8((uint8_t *)Bytes_val(v2), v.val[2]);
  result = caml_alloc(3, 0);
  Store_field(result, 0, v0); Store_field(result, 1, v1); Store_field(result, 2, v2);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vst3q_u8(value buf, value off, value rec3)
{
  CAMLparam3(buf, off, rec3);
  uint8x16x3_t v;
  v.val[0] = vld1q_u8((const uint8_t *)Bytes_val(Field(rec3, 0)));
  v.val[1] = vld1q_u8((const uint8_t *)Bytes_val(Field(rec3, 1)));
  v.val[2] = vld1q_u8((const uint8_t *)Bytes_val(Field(rec3, 2)));
  vst3q_u8((uint8_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vld3q_s16(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal4(result, v0, v1, v2);
  const int16_t *ptr = (const int16_t *)(Bytes_val(buf) + Int_val(off));
  int16x8x3_t v = vld3q_s16(ptr);
  v0 = caml_alloc_string(16); vst1q_s16((int16_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_s16((int16_t *)Bytes_val(v1), v.val[1]);
  v2 = caml_alloc_string(16); vst1q_s16((int16_t *)Bytes_val(v2), v.val[2]);
  result = caml_alloc(3, 0);
  Store_field(result, 0, v0); Store_field(result, 1, v1); Store_field(result, 2, v2);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vst3q_s16(value buf, value off, value rec3)
{
  CAMLparam3(buf, off, rec3);
  int16x8x3_t v;
  v.val[0] = vld1q_s16((const int16_t *)Bytes_val(Field(rec3, 0)));
  v.val[1] = vld1q_s16((const int16_t *)Bytes_val(Field(rec3, 1)));
  v.val[2] = vld1q_s16((const int16_t *)Bytes_val(Field(rec3, 2)));
  vst3q_s16((int16_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vld3q_s32(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal4(result, v0, v1, v2);
  const int32_t *ptr = (const int32_t *)(Bytes_val(buf) + Int_val(off));
  int32x4x3_t v = vld3q_s32(ptr);
  v0 = caml_alloc_string(16); vst1q_s32((int32_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_s32((int32_t *)Bytes_val(v1), v.val[1]);
  v2 = caml_alloc_string(16); vst1q_s32((int32_t *)Bytes_val(v2), v.val[2]);
  result = caml_alloc(3, 0);
  Store_field(result, 0, v0); Store_field(result, 1, v1); Store_field(result, 2, v2);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vst3q_s32(value buf, value off, value rec3)
{
  CAMLparam3(buf, off, rec3);
  int32x4x3_t v;
  v.val[0] = vld1q_s32((const int32_t *)Bytes_val(Field(rec3, 0)));
  v.val[1] = vld1q_s32((const int32_t *)Bytes_val(Field(rec3, 1)));
  v.val[2] = vld1q_s32((const int32_t *)Bytes_val(Field(rec3, 2)));
  vst3q_s32((int32_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

/* ------------------------------------------------------------------ */
/* vld4 / vst4                                                         */
/* ------------------------------------------------------------------ */

CAMLprim value caml_seraph_vld4q_f32(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  CAMLlocal4(v0, v1, v2, v3);
  const float *ptr = (const float *)(Bytes_val(buf) + Int_val(off));
  float32x4x4_t v = vld4q_f32(ptr);
  v0 = caml_alloc_string(16); vst1q_f32((float *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_f32((float *)Bytes_val(v1), v.val[1]);
  v2 = caml_alloc_string(16); vst1q_f32((float *)Bytes_val(v2), v.val[2]);
  v3 = caml_alloc_string(16); vst1q_f32((float *)Bytes_val(v3), v.val[3]);
  result = caml_alloc(4, 0);
  Store_field(result, 0, v0); Store_field(result, 1, v1);
  Store_field(result, 2, v2); Store_field(result, 3, v3);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vst4q_f32(value buf, value off, value rec4)
{
  CAMLparam3(buf, off, rec4);
  float32x4x4_t v;
  v.val[0] = vld1q_f32((const float *)Bytes_val(Field(rec4, 0)));
  v.val[1] = vld1q_f32((const float *)Bytes_val(Field(rec4, 1)));
  v.val[2] = vld1q_f32((const float *)Bytes_val(Field(rec4, 2)));
  v.val[3] = vld1q_f32((const float *)Bytes_val(Field(rec4, 3)));
  vst4q_f32((float *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vld4q_s8(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  CAMLlocal4(v0, v1, v2, v3);
  const int8_t *ptr = (const int8_t *)(Bytes_val(buf) + Int_val(off));
  int8x16x4_t v = vld4q_s8(ptr);
  v0 = caml_alloc_string(16); vst1q_s8((int8_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_s8((int8_t *)Bytes_val(v1), v.val[1]);
  v2 = caml_alloc_string(16); vst1q_s8((int8_t *)Bytes_val(v2), v.val[2]);
  v3 = caml_alloc_string(16); vst1q_s8((int8_t *)Bytes_val(v3), v.val[3]);
  result = caml_alloc(4, 0);
  Store_field(result, 0, v0); Store_field(result, 1, v1);
  Store_field(result, 2, v2); Store_field(result, 3, v3);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vst4q_s8(value buf, value off, value rec4)
{
  CAMLparam3(buf, off, rec4);
  int8x16x4_t v;
  v.val[0] = vld1q_s8((const int8_t *)Bytes_val(Field(rec4, 0)));
  v.val[1] = vld1q_s8((const int8_t *)Bytes_val(Field(rec4, 1)));
  v.val[2] = vld1q_s8((const int8_t *)Bytes_val(Field(rec4, 2)));
  v.val[3] = vld1q_s8((const int8_t *)Bytes_val(Field(rec4, 3)));
  vst4q_s8((int8_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vld4q_u8(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  CAMLlocal4(v0, v1, v2, v3);
  const uint8_t *ptr = (const uint8_t *)(Bytes_val(buf) + Int_val(off));
  uint8x16x4_t v = vld4q_u8(ptr);
  v0 = caml_alloc_string(16); vst1q_u8((uint8_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_u8((uint8_t *)Bytes_val(v1), v.val[1]);
  v2 = caml_alloc_string(16); vst1q_u8((uint8_t *)Bytes_val(v2), v.val[2]);
  v3 = caml_alloc_string(16); vst1q_u8((uint8_t *)Bytes_val(v3), v.val[3]);
  result = caml_alloc(4, 0);
  Store_field(result, 0, v0); Store_field(result, 1, v1);
  Store_field(result, 2, v2); Store_field(result, 3, v3);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vst4q_u8(value buf, value off, value rec4)
{
  CAMLparam3(buf, off, rec4);
  uint8x16x4_t v;
  v.val[0] = vld1q_u8((const uint8_t *)Bytes_val(Field(rec4, 0)));
  v.val[1] = vld1q_u8((const uint8_t *)Bytes_val(Field(rec4, 1)));
  v.val[2] = vld1q_u8((const uint8_t *)Bytes_val(Field(rec4, 2)));
  v.val[3] = vld1q_u8((const uint8_t *)Bytes_val(Field(rec4, 3)));
  vst4q_u8((uint8_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vld4q_s16(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  CAMLlocal4(v0, v1, v2, v3);
  const int16_t *ptr = (const int16_t *)(Bytes_val(buf) + Int_val(off));
  int16x8x4_t v = vld4q_s16(ptr);
  v0 = caml_alloc_string(16); vst1q_s16((int16_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_s16((int16_t *)Bytes_val(v1), v.val[1]);
  v2 = caml_alloc_string(16); vst1q_s16((int16_t *)Bytes_val(v2), v.val[2]);
  v3 = caml_alloc_string(16); vst1q_s16((int16_t *)Bytes_val(v3), v.val[3]);
  result = caml_alloc(4, 0);
  Store_field(result, 0, v0); Store_field(result, 1, v1);
  Store_field(result, 2, v2); Store_field(result, 3, v3);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vst4q_s16(value buf, value off, value rec4)
{
  CAMLparam3(buf, off, rec4);
  int16x8x4_t v;
  v.val[0] = vld1q_s16((const int16_t *)Bytes_val(Field(rec4, 0)));
  v.val[1] = vld1q_s16((const int16_t *)Bytes_val(Field(rec4, 1)));
  v.val[2] = vld1q_s16((const int16_t *)Bytes_val(Field(rec4, 2)));
  v.val[3] = vld1q_s16((const int16_t *)Bytes_val(Field(rec4, 3)));
  vst4q_s16((int16_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}

CAMLprim value caml_seraph_vld4q_s32(value buf, value off)
{
  CAMLparam2(buf, off);
  CAMLlocal1(result);
  CAMLlocal4(v0, v1, v2, v3);
  const int32_t *ptr = (const int32_t *)(Bytes_val(buf) + Int_val(off));
  int32x4x4_t v = vld4q_s32(ptr);
  v0 = caml_alloc_string(16); vst1q_s32((int32_t *)Bytes_val(v0), v.val[0]);
  v1 = caml_alloc_string(16); vst1q_s32((int32_t *)Bytes_val(v1), v.val[1]);
  v2 = caml_alloc_string(16); vst1q_s32((int32_t *)Bytes_val(v2), v.val[2]);
  v3 = caml_alloc_string(16); vst1q_s32((int32_t *)Bytes_val(v3), v.val[3]);
  result = caml_alloc(4, 0);
  Store_field(result, 0, v0); Store_field(result, 1, v1);
  Store_field(result, 2, v2); Store_field(result, 3, v3);
  CAMLreturn(result);
}

CAMLprim value caml_seraph_vst4q_s32(value buf, value off, value rec4)
{
  CAMLparam3(buf, off, rec4);
  int32x4x4_t v;
  v.val[0] = vld1q_s32((const int32_t *)Bytes_val(Field(rec4, 0)));
  v.val[1] = vld1q_s32((const int32_t *)Bytes_val(Field(rec4, 1)));
  v.val[2] = vld1q_s32((const int32_t *)Bytes_val(Field(rec4, 2)));
  v.val[3] = vld1q_s32((const int32_t *)Bytes_val(Field(rec4, 3)));
  vst4q_s32((int32_t *)(Bytes_val(buf) + Int_val(off)), v);
  CAMLreturn(Val_unit);
}
