
# enx-rtc-react-native

## Getting started

`$ npm install enx-rtc-react-native --save`

### Mostly automatic installation

`$ react-native link enx-rtc-react-native`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `enx-rtc-react-native` and add `EnxRtc.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libEnxRtc.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.rnenxrtc.EnxRtcPackage;` to the imports at the top of the file
  - Add `new EnxRtcPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':enx-rtc-react-native'
  	project(':enx-rtc-react-native').projectDir = new File(rootProject.projectDir, 	'../node_modules/enx-rtc-react-native/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':enx-rtc-react-native')
  	```

## Usage
```javascript
import EnxRtc from 'enx-rtc-react-native';

// TODO: What to do with the module?
EnxRtc;
```
  