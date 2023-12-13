import {
  StyleSheet, 
  Text,
  View,
  ScrollView,
  ScrollViewComponent
} from 'react-native';

import Header form "../components/header.tsx"
import Footer form "../components/footer.tsx.tsx"


export default function BloodSugarLogs() {
  return (
    <View styles>
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
    backgroundColor: '#000',
    color: "#fff",
    alignItems: 'center',
    justifyContent: 'center',
  },

});
