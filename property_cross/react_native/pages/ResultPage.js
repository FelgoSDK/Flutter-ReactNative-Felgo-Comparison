import React from 'react';
import {AsyncStorage, FlatList, Dimensions} from 'react-native';
import {
    Body,
    Button,
    Container,
    Content,
    Header,
    Icon,
    Left,
    ListItem,
    Right,
    Spinner,
    Text,
    Thumbnail,
    Title
} from 'native-base';

export default class ResultPage extends React.PureComponent {
    state = {
        listings: [],
        total_results: 0,
        loading: false
    };

    list = React.createRef();

    query = this.props.navigation.getParam("query");
    coords = this.props.navigation.getParam("coords");

    page = 1;

    navigateBack() {
        this.props.navigation.goBack();
    }

    encodeParams(params) {
        return Object.entries(params).map(kv => kv.map(encodeURIComponent).join("=")).join("&");
    }

    requestNextPage() {
        if (this.state.loading) return;

        this.setState({
            loading: true
        });

        const params = {
            country: 'uk',
            pretty: '1',
            encoding: 'json',
            listing_type: 'buy',
            action: 'search_listings',
            page: this.page++,
        };

        if (this.query)
            params.place_name = this.query;

        if (this.coords)
            params.centre_point = this.coords.latitude + ',' + this.coords.longitude;

        return fetch('https://felgo.com/mockapi-propertycross?' + this.encodeParams(params)).then(res => res.json()).then(res => {
            this.setState({
                listings: this.state.listings.concat(res.response.listings),
                total_results: res.response.total_results,
                loading: false
            });
        });
    }

    componentDidMount(): void {
        this.requestNextPage().then(req => {
            if (this.query)
                AsyncStorage.getItem('recent_searches', (err, data) => {
                    let recent_searches = [...(JSON.parse(data) || []), {
                        query: this.query,
                        listings: this.state.total_results
                    }];
                    AsyncStorage.setItem('recent_searches', JSON.stringify(recent_searches));
                });
        });
    }

    renderRow({item, index}) {
        return <ListItem key={index} onPress={() => this.props.navigation.navigate('Details', {listing: item})} thumbnail itemDivider>
            <Left>
                <Thumbnail square source={{uri: item.thumb_url}}/>
            </Left>
            <Body>
                <Text>{item.price_formatted}</Text>
                <Text note numberOfLines={1}>{item.title}</Text>
            </Body>
        </ListItem>
    }

    endReached({distanceFromEnd}) {
        this.requestNextPage()
    }

    render() {

        return <Container>
            <Header>
                <Button transparent onPress={this.navigateBack.bind(this)}><Icon name="arrow-back"/></Button>
                <Body>
                    <Title>{this.state.listings.length} of {this.state.total_results} matches</Title>
                </Body>
                <Right>
                    {this.state.loading &&
                    <Spinner color='white'/>
                    }
                </Right>
            </Header>
            <Content>
                <FlatList
                    data={this.state.listings}
                    renderItem={this.renderRow.bind(this)}
                    onEndReached={this.endReached.bind(this)}
                    onEndReachedThreshold={0.1}
                    style={{height: Dimensions.get('window').height*0.9}}
                    ListFooterComponent={this.state.loading && <Spinner color='darkblue'/>}
                    ref={this.list}
                />

            </Content>
        </Container>
    }
}
