# 核心准则五：Type-Safe 导航与多形态 Preview 体系 (Type-Safe Navigation & Preview)

## 1. 现代化类型安全导航 (Type-Safe Navigation Compose)

* **弃用字符串拼接路由**：全面废弃如 `"profile/{userId}?name={name}"` 的易错字符串路由；
* **使用 `@Serializable` 对象/数据类作为路由目标**：

```kotlin
import kotlinx.serialization.Serializable

// 1. 定义类型安全的路由对象
@Serializable
object HomeRoute

@Serializable
data class ProfileRoute(val userId: String, val fromSearch: Boolean = false)

// 2. 在 NavHost 中配置
NavHost(navController = navController, startDestination = HomeRoute) {
    composable<HomeRoute> {
        HomeScreen(onNavigateToProfile = { userId ->
            navController.navigate(ProfileRoute(userId = userId))
        })
    }
    composable<ProfileRoute> { backStackEntry ->
        val route: ProfileRoute = backStackEntry.toRoute()
        ProfileScreen(userId = route.userId)
    }
}
```

---

## 2. 规范的多形态 Preview 体系

编写 Composable 组件时，必须配套提供支持多形态的 Preview，确保在不同系统状态下视觉表现一致：

### 多形态 Preview 标准组合注解
```kotlin
// 提供深浅色与多屏幕尺寸的复合预览
@Preview(name = "Light Mode", showBackground = true)
@Preview(name = "Dark Mode", uiMode = Configuration.UI_MODE_NIGHT_YES, showBackground = true)
@Preview(name = "Foldable Screen", device = "spec:width=673dp,height=841dp")
annotation class MultiThemeAndDevicePreviews

@MultiThemeAndDevicePreviews
@Composable
private fun ProjectCardPreview() {
    AppTheme {
        ProjectCard(
            project = mockProjectItem,
            onClick = {}
        )
    }
}
```

### Preview 传入 Mock 数据约束
* Preview 内部必须传入纯粹的无状态 Mock 数据，严禁在 Preview 中触发实际的网络请求、数据库查询或依赖真正的 ViewModel。
