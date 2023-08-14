import * as React from "react";
import {
  requireNativeComponent,
  StyleSheet,
  NativeModules,
} from "react-native";

import { IMapboxNavigationProps } from "./typings";

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

const MapboxNavigation = (props: IMapboxNavigationProps) => {
  return <RNMapboxNavigation style={styles.container} {...props} />;
};

const RNMapboxNavigation = requireNativeComponent(
  "MapboxNavigation",
  MapboxNavigation,
);

const RNTMapboxNavigationView = requireNativeComponent("RNTMapBoxNavigation");

export const RNTMapboxNavigation = () => {
  return <RNTMapboxNavigationView style={styles.container} />;
};

console.log({ NativeModule: NativeModules });

// export const rn = NativeModules.RNTMapBoxNavigationManager.startNavigation;

export const { endNavigation, startNavigation } =
  NativeModules.RNTMapBoxNavigationManager;

export const useRnMapboxNavigation = () => {
  return {
    startNavigation,
    endNavigation,
  };
};

export default MapboxNavigation;
