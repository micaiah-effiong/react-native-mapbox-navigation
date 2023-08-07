import * as React from "react";
import { requireNativeComponent, StyleSheet } from "react-native";

import { IMapboxNavigationProps } from "./typings";

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

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

export default MapboxNavigation;
