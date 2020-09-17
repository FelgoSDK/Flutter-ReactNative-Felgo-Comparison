import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

const styles = StyleSheet.create({
  container: {
    alignSelf: 'center',
    paddingTop: 30,
    paddingBottom: 30,
  },
  headline: {
    alignSelf: 'center',
    fontSize: 20,
    fontWeight: 'bold',
  },
  showingList: {
    flexDirection: "row",
    justifyContent: "space-around",
    paddingTop: 20,
  },
  showing: {
    fontSize: 20,
  }
})

export function ShowingTimes(props) {
  if (! props.showings.map) return null 
  const showings = props.showings.map(showing => ({ ...showing, showing_time: formatShowingTime(showing.showing_time) }))
  return (
    <View style={styles.container}>
      <Text style={styles.headline}>Showing times for {props.selected_date.toDateString()} for {props.film.title}</Text>
      <View style={styles.showingList}>
        {showings.map(showing => <Text onPress={() => props.chooseTime(showing)} key={showing.id} style={styles.showing}>{showing.showing_time}</Text>)}
      </View>
    </View>
  )
}

function formatShowingTime(showing_time) {
  const t = new Date(showing_time);
  const h = t.getHours();
  const m = t.getMinutes();
  //const hh = h < 10 ? 0 + h : h;
  return `${h > 12 ? h - 12 : h}:${m < 10 ? "0"+m : m} ${h < 12 ? "am" : "pm"}`
}