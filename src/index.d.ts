declare module "@homee/react-native-mapbox-navigation" {
  /** RNTMapBoxNavigation */
  export function useRnMapboxNavigation(): {
    startNavigation: () // origin: [number, number],
    // destination: [number, number],
    => void;

    endNavigation: () => void;
  };
}
