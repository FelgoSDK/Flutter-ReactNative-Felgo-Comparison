import React from "react";
import {AsyncStorage, Dimensions, Image} from "react-native";
import {Body, Button, Container, Content, Header, Icon, Right, Text, Title} from "native-base";

export default class DetailPage extends React.PureComponent {

    state = {
        liked: false
    };

    listing = this.props.navigation.getParam('listing');

    componentDidMount(): void {
        AsyncStorage.getItem('liked').then(likedListString => {
            let likedList = JSON.parse(likedListString);
            for (let likedItem of likedList)
                if (JSON.stringify(this.listing) === JSON.stringify(likedItem)) {
                    this.setState({
                        liked: true
                    });
                    break;
                }
        });

    }

    componentWillUnmount(): void {
        AsyncStorage.getItem('liked', (err, res) => {
            let likedList = (JSON.parse(res) || []).filter(likedItem => JSON.stringify(likedItem) !== JSON.stringify(this.listing));
            if (this.state.liked)
                likedList.push(this.listing);
            AsyncStorage.setItem('liked', JSON.stringify(likedList));
        });
    }

    switchLiked() {
        this.setState({
            liked: !this.state.liked
        });
    }

    navigateBack() {
        this.props.navigation.goBack();
    }

    render() {

        return <Container>
            <Header>
                <Button transparent onPress={this.navigateBack.bind(this)}><Icon name="arrow-back"/></Button>
                <Body>
                    <Title>Property Details</Title>
                </Body>
                <Right>
                    <Button onPress={this.switchLiked.bind(this)} transparent>
                        <Icon type="AntDesign" name={this.state.liked ? 'heart' : 'hearto'}/>
                    </Button>
                </Right>
            </Header>
            <Content style={{padding: 10}}>
                <Text style={{fontSize: 35}}>{this.listing.price_formatted.toString()}</Text>
                <Text>{this.listing.title.toString()}</Text>
                <Image resizeMode="contain" source={{uri: this.listing.img_url.toString()}} style={{
                    width: Dimensions.get('window').width-20,
                    height: Dimensions.get('window').width-20
                }}/>
                <Text>{this.listing.bedroom_number.toString()} bed, {this.listing.bathroom_number.toString()} bathrooms</Text>
                <Text>{this.listing.summary.toString()}</Text>
            </Content>
        </Container>;
    };
}