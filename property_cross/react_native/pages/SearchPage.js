import React from 'react';
import {Alert, AsyncStorage, Dimensions, FlatList, TouchableOpacity} from 'react-native';
import {Body, Button, Container, Content, Header, Icon, Input, Item, Right, Row, Text, Title} from 'native-base';
import Geolocation from '@react-native-community/geolocation';

class RecentSearchesView extends React.PureComponent {
    state = {
        recent_searches: []
    };

    itemStyle = {
        padding: 15
    };

    renderItem({item}) {
        let pressHandler = this.props.navigation.navigate.bind(this, 'Result', {query: item.query});
        return <TouchableOpacity onPress={pressHandler} style={this.itemStyle}>
            <Text>{item.query} ({item.listings} listings)</Text>
        </TouchableOpacity>;
    }

    componentDidMount(): void {
        this.props.navigation.addListener ('willFocus', () =>{
            AsyncStorage.getItem('recent_searches', (err, res) => {
                let recent_searches = JSON.parse(res);
                if (recent_searches !== this.state.recent_searches)
                    this.setState({
                        recent_searches: JSON.parse(res)
                    });
            });
        });
    }

    render() {
        let header = <Text style={{color: 'darkblue'}}>Recent Searches</Text>;
        return <FlatList ListHeaderComponent={header} style={{height: Dimensions.get('window').height * 0.5}} data={this.state.recent_searches} renderItem={this.renderItem.bind(this)}/>;
    }
}

export default class SearchPage extends React.PureComponent {

    state = {
        search_query: '',
        bottom_msg: ''

    };

    search(by) {
        switch (by) {
            case 'text':
                if (this.state.search_query === '')
                    this.setState({
                        bottom_msg: 'There was a problem with your search'
                    });
                else
                    this.props.navigation.navigate('Result', {query: this.state.search_query});
                break;

            case 'location':
                Geolocation.getCurrentPosition(position => {
                    this.props.navigation.navigate('Result', {coords: position.coords});
                }, error => Alert.alert(error.message));
                break;
        }
    }

    openLiked() {
        this.props.navigation.navigate('Liked');
    }

    render() {
        return <Container>
            <Header>
                <Body>
                    <Title>Property Cross</Title>
                </Body>
                <Right>
                    <Button transparent onPress={this.openLiked.bind(this)}>
                        <Icon name="heart"/>
                    </Button>
                </Right>
            </Header>
            <Content style={{padding: 10}}>
                <Text>
                    Use the form below to search for houses to buy.
                    You can search by place-name, postcode, or click 'My location',
                    to search in your current location.
                </Text>
                <Text style={{fontStyle: 'italic', color: 'gray', margin: 5}}>
                    Hint: You can quickly find and view results by searching 'London'.
                </Text>
                <Item>
                    <Input placeholder="Search" onChangeText={text => this.setState({
                        search_query: text,
                        bottom_msg: ''
                    })}/>
                </Item>
                <Row style={{margin: 10}}>
                    <Button onPress={this.search.bind(this, 'text')} style={{margin: 10}}><Text>Go!</Text></Button>
                    <Button onPress={this.search.bind(this, 'location')} style={{margin: 10}}><Text>My
                        location</Text></Button>
                </Row>
                {
                    this.state.bottom_msg === '' ?
                        <RecentSearchesView navigation={this.props.navigation}/> :
                        <Text>{this.state.bottom_msg}</Text>
                }
            </Content>
        </Container>;
    };
}