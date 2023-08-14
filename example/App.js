/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, {useEffect} from 'react';
import {SafeAreaView, View, useColorScheme, Button} from 'react-native';
import {Colors} from 'react-native/Libraries/NewAppScreen';
import NavigationComponent from './NavigationComponent';
import {PermissionsAndroid, Text, PlatformOSType} from 'react-native';
import {
  RNTMapboxNavigation,
  useRnMapboxNavigation,
} from '@homee/react-native-mapbox-navigation';

const App = () => {
  const isDarkMode = useColorScheme() === 'dark';

  const {startNavigation, endNavigation} = useRnMapboxNavigation();

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
    textColor: 'red',
    flex: 1,
  };

  useEffect(() => {
    const requestLocationPermission = async () => {
      try {
        await PermissionsAndroid.request(
          PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
          {
            title: 'Example App',
            message: 'Example App access to your location ',
          },
        );
      } catch (err) {
        console.warn(err);
      }
    };
    if (PlatformOSType === 'android') {
      requestLocationPermission();
    }
  }, []);

  return (
    <SafeAreaView style={backgroundStyle}>
      {/*<NavigationComponent
        origin={[-105.140629, 39.760194]}
        destination={[-105.156544, 39.761801]}
      />*/}
      <Text> Hi dsfds </Text>
      <RNTMapboxNavigation />
      <Text> Hi dsfds </Text>
      <Button onPress={() => startNavigation()} title="Start navigation" />
      <Button onPress={() => endNavigation()} title="End navigation" />
    </SafeAreaView>
  );
};

export default App;
