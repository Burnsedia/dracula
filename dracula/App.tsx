import { StyleSheet, Text, View } from 'react-native';
import { NavigationContainer,  } from '@react-navigation/native';
import { createNativeStackNavigator } from "@react-navigation/native-stack"
import Login from "pages/login"


const Stack =  createNativeStackNavigator()
export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator>
      Home   
      </Stack.Navigator>
      <Stack.Navigator>
      Logs   
      </Stack.Navigator>
     <Stack.Navigator>
      Settings
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
