import { StyleSheet, Text, View } from 'react-native';
import { NavigationContainer,  } from '@react-navigation/native';
import { createNativeStackNavigator } from "@react-navigation/native-stack"
import BloodSugarLogs from './pages/bloodsugarHistory';

const Stack =  createNativeStackNavigator()
export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator>
      Home  
      <Stack.Screen name="Home" component={BloodSugarLogs}/>
      </Stack.Navigator>
      <Stack.Navigator>
      Logs   
      <Stack.Screen name="Logs" component={BloodSugarLogs}/>
      </Stack.Navigator>
     <Stack.Navigator>
      Settings
      <Stack.Screen name="Home" component={BloodSugarLogs}/>

    </Stack.Navigator>
    </NavigationContainer> 
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
