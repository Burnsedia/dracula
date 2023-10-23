import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View } from 'react-native';
// import { NavigationBar } from 'expo-navigation-bar';
export default function App() {
  return (
    <View style={styles.container}>
      {/* <NavigationBar style="auto"/> */}
      <Text>A Privacy Focused Blood Sugar Tracking app</Text>
      <Text>A Privacy Focused Blood Sugar Tracking app</Text>
      {/* <StatusBar style="auto" /> */}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
