import { StyleSheet, Text, View, ScrollView, ScrollViewComponent } from 'react-native';


export default function App() {
  return (
    <View>
      <ScrollView>
        <ScrollViewComponent>
          <Text>
          BloodSugur: 100
          </Text>
        </ScrollViewComponent>
        <ScrollViewComponent>
          <Text>
          BloodSugur: 150
          </Text>
        </ScrollViewComponent>
        <ScrollViewComponent>
          <Text>
          BloodSugur: 200
          </Text>
        </ScrollViewComponent>
      </ScrollView> 
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
