fixture = null
casper.start 'http://localhost:8080/test-data/reset', ->
    @test.assertHttpStatus 200, 'test data is reset'
    fixture = JSON.parse(@fetchText('pre'))

casper.then ->
    @open "http://localhost:8080/album#/show/#{fixture[0].id}"

casper.then ->
    @test.assertUrlMatch /#\/show\/\d+$/, 'show view is loaded'
    @waitForSelector '[data-ng-bind="item.artist"]:not(:empty)', ->
        @test.info 'item details are displayed correctly'
        @test.assertEquals @fetchText('[data-ng-bind="item.artist"]'), fixture[0].artist, 'album artist is correct'
        @test.assertEquals @fetchText('[data-ng-bind="item.title"]'), fixture[0].title, 'album title is correct'
    , ->
        @test.fail 'data should have loaded into the show page'

casper.run ->
    @test.done()