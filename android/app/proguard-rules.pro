# 1. Keep the Health Connect client classes safe from renaming
-keep class androidx.health.connect.client.** { *; }
-keep class androidx.health.platform.client.** { *; }

# 2. Keep the generic Kotlin classes used for data transfer
-keep class kotlin.Metadata { *; }
-keep class kotlin.coroutines.** { *; }

# 3. Keep your permission activity
-keep class com.example.rep_rise.ViewPermissionUsageActivity { *; }