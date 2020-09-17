import React from 'react';
import {AsyncStorage} from 'react-native';
import {
    Body,
    Button,
    Container,
    Content,
    Header,
    Icon,
    Left,
    List,
    ListItem,
    Text,
    Thumbnail,
    Title
} from 'native-base';

export default class ResultPage extends React.PureComponent {
    state = {
        listings: []
    };

    navigateBack() {
        this.props.navigation.goBack();
    }

    componentDidMount(): void {
        AsyncStorage.getItem('liked').then(likedListString => {
            let likedList = JSON.parse(likedListString);
            this.setState({
                listings: likedList || []
            });
        });
    }

    navigateToListing(listing) {
        this.props.navigation.navigate('Details', {listing});
    }

    render() {

        return <Container>
            <Header>
                <Button transparent onPress={this.navigateBack.bind(this)}><Icon name="arrow-back"/></Button>
                <Body>
                    <Title>Favourites</Title>
                </Body>
            </Header>
            <Content>
                {this.state.listings.length < 1 ?
                    <Text style={{margin: 100}}>You have not added any properties to your favourites.</Text> :
                    <List>
                        {this.state.listings.map(listing => (
                            <ListItem onPress={this.navigateToListing.bind(this, listing)} thumbnail itemDivider>
                                <Left>
                                    <Thumbnail square source={{uri: listing.thumb_url}}/>
                                </Left>
                                <Body>
                                    <Text>{listing.price_formatted}</Text>
                                    <Text note numberOfLines={1}>{listing.title}</Text>
                                </Body>
                            </ListItem>
                        ))}
                    </List>
                }</Content>
        </Container>
    }
}