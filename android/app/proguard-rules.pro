-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }

# Suppress warnings about missing classes
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options