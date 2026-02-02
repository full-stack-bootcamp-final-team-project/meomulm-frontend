# Kakao Map SDK
-keep class com.kakao.vectormap.** { *; }
-keep interface com.kakao.vectormap.**

# Stripe 관련 규칙
-keep class com.stripe.android.pushProvisioning.** { *; }
-keep class com.stripe.android.** { *; }
-dontwarn com.stripe.android.pushProvisioning.**

# React Native Stripe SDK
-keep class com.reactnativestripesdk.** { *; }
-dontwarn com.reactnativestripesdk.**