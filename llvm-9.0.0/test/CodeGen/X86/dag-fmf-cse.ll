; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=fma -enable-unsafe-fp-math | FileCheck %s

; If fast-math-flags are propagated correctly, the mul1 expression
; should be recognized as a factor in the last fsub, so we should
; see a mul and add, not a mul and fma:
; a * b - (-a * b) ---> (a * b) + (a * b)

define float @fmf_should_not_break_cse(float %a, float %b) {
; CHECK-LABEL: fmf_should_not_break_cse:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmulss %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vaddss %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %mul1 = fmul fast float %a, %b
  %nega = fsub fast float 0.0, %a
  %mul2 = fmul fast float %nega, %b
  %abx2 = fsub fast float %mul1, %mul2
  ret float %abx2
}

define float @fmf_should_not_break_cse_unary_fneg(float %a, float %b) {
; CHECK-LABEL: fmf_should_not_break_cse_unary_fneg:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmulss %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vaddss %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %mul1 = fmul fast float %a, %b
  %nega = fneg fast float %a
  %mul2 = fmul fast float %nega, %b
  %abx2 = fsub fast float %mul1, %mul2
  ret float %abx2
}

define <4 x float> @fmf_should_not_break_cse_vector(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: fmf_should_not_break_cse_vector:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vaddps %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %mul1 = fmul fast <4 x float> %a, %b
  %nega = fsub fast <4 x float> <float 0.0, float 0.0, float 0.0, float 0.0>, %a
  %mul2 = fmul fast <4 x float> %nega, %b
  %abx2 = fsub fast <4 x float> %mul1, %mul2
  ret <4 x float> %abx2
}

define <4 x float> @fmf_should_not_break_cse_vector_unary_fneg(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: fmf_should_not_break_cse_vector_unary_fneg:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vaddps %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %mul1 = fmul fast <4 x float> %a, %b
  %nega = fneg fast <4 x float> %a
  %mul2 = fmul fast <4 x float> %nega, %b
  %abx2 = fsub fast <4 x float> %mul1, %mul2
  ret <4 x float> %abx2
}
