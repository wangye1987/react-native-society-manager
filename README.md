
# react-native-society-manager

## Getting started

`$ npm install react-native-society-manager --save`

or

`$ yarn add react-native-society-manager`
### Mostly automatic installation

`$ react-native link react-native-society-manager`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-society-manager` and add `SocietyManager.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libSocietyManager.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.component.SocietyManagerPackage` to the imports at the top of the file
  - Add `  new SocietyManagerPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-society-manager'
	project(':react-native-society-manager').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-society-manager/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
       implementation project(':react-native-society-manager')
  	```


## Usage
```javascript
import * as society from 'react-native-society-manager'

// TODO: What to do with the module?
sendAuthRequest是唤起微信登录的方法，await代表异步返回结果：true或者false，参数代表平台类型，可以传0，sendAuthRequest是android暴露的方法，供rn调用，从而调起微信
let codeResponse = await society.sendAuthRequest(0)
```
  
