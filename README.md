
# react-native-society-manager

## Getting started

`$ npm install react-native-society-manager --save`

### Mostly automatic installation

`$ react-native link react-native-society-manager`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-society-manager` and add `MTDSocietyManager.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libMTDSocietyManager.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.MTDSocietyManagerPackage;` to the imports at the top of the file
  - Add `new MTDSocietyManagerPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-society-manager'
  	project(':react-native-society-manager').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-society-manager/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-society-manager')
  	```


## Usage
```javascript
import MTDSocietyManager from 'react-native-society-manager';

// TODO: What to do with the module?
MTDSocietyManager;
```
  