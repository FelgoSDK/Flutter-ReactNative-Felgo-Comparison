/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import {createAppContainer, createStackNavigator} from 'react-navigation';
import SearchPage from './pages/SearchPage';
import ResultPage from './pages/ResultPage';
import DetailPage from "./pages/DetailPage";
import LikedPage from "./pages/LikedPage";

const MainNavigator = createStackNavigator({
    Search: {screen: SearchPage},
    Result: {screen: ResultPage},
    Details: {screen: DetailPage},
    Liked: {screen: LikedPage}
}, {
    initialRouteName: 'Search',
    headerMode: 'none',
    navigationOptions: {
        headerVisible: false,
    }
});

const App = createAppContainer(MainNavigator);

export default App;
