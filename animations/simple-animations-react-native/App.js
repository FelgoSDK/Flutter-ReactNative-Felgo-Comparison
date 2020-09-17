import React, { Component } from 'react'
 
import {
StyleSheet,
TouchableOpacity,
Text,
View,
Animated,
} from 'react-native'
class App extends Component {
 
state = {
  currentOpacity: new Animated.Value(0),
  targetOpacity: 1
}
onPress = () => {
  var newTargetOpacity = this.state.targetOpacity > 0 ? 0 : 1
  this.setState({ targetOpacity: newTargetOpacity })
  Animated.timing(
     this.state.currentOpacity,
     { toValue: this.state.targetOpacity, duration: 2000 }
   ).start();
}
render() {
  return (
    <View style={styles.container}>
      <TouchableOpacity
       style={styles.button}
       onPress={this.onPress}
      >
       <Text>Click me</Text>
      </TouchableOpacity>
      <Animated.View style={{opacity: this.state.currentOpacity}}>
        <Text>
          I slowly fade in!
        </Text>
      </Animated.View>
    </View>
  )
}
}
const styles = StyleSheet.create({
container: {
  flex: 1,
  justifyContent: 'center',
  alignItems: 'center',
},
button: {
  alignItems: 'center',
  backgroundColor: '#DDDDDD',
  padding: 10,
  marginBottom: 10
}
})
export default App;
