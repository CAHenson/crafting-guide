###
Crafting Guide - mod_pack.test.coffee

Copyright (c) 2014-2015 by Redwood Labs
All rights reserved.
###

Item       = require '../src/scripts/models/item'
Mod        = require '../src/scripts/models/mod'
ModPack    = require '../src/scripts/models/mod_pack'
ModVersion = require '../src/scripts/models/mod_version'

########################################################################################################################

buildcraft = industrialCraft = minecraft = modPack = null

########################################################################################################################

describe 'mod_pack.coffee', ->

    beforeEach ->
        minecraft = new Mod slug:'minecraft'
        minecraft.addModVersion new ModVersion modSlug:minecraft.slug, version:'1.7.10'
        minecraft.activeModVersion.addItem new Item name:'Wool'
        minecraft.activeModVersion.addItem new Item name:'Bed', recipes:['']
        minecraft.activeModVersion.registerSlug 'iron_chestplate', 'Iron Chestplate'

        buildcraft = new Mod slug:'buildcraft'
        buildcraft.addModVersion new ModVersion modSlug:buildcraft.slug, version:'6.2.6'
        buildcraft.activeModVersion.addItem new Item name:'Stone Gear', recipes:['']
        buildcraft.activeModVersion.addItem new Item name:'Bed', recipes:['']
        buildcraft.activeVersion = Mod.Version.None

        industrialCraft = new Mod slug:'industrial_craft'
        industrialCraft.addModVersion new ModVersion modSlug:industrialCraft.slug, version:'2.0'
        industrialCraft.activeModVersion.addItem new Item name:'Resin'
        industrialCraft.activeModVersion.addItem new Item name:'Rubber'
        industrialCraft.activeVersion = Mod.Version.None

        modPack = new ModPack
        modPack.addMod minecraft
        modPack.addMod buildcraft
        modPack.addMod industrialCraft

    describe 'findItemByName', ->

        it 'finds the requested item', ->
            item = modPack.findItemByName 'Bed'
            item.name.should.equal 'Bed'

        it 'ignores disabled mod versions', ->
            item = modPack.findItemByName 'Stone Gear'
            expect(item).to.be.null

    describe 'findItemDisplay', ->

        it 'returns all data for a regular Minecraft item', ->
            display = modPack.findItemDisplay 'bed'
            display.iconUrl.should.equal '/data/minecraft/1.7.10/images/bed.png'
            display.itemUrl.should.equal '/item/bed'
            display.itemName.should.equal 'Bed'
            display.modSlug.should.equal 'minecraft'

        it 'returns all data for an item in an enabled mod', ->
            buildcraft.activeVersion = '6.2.6'
            display = modPack.findItemDisplay 'stone_gear'
            display.iconUrl.should.equal '/data/buildcraft/6.2.6/images/stone_gear.png'
            display.itemUrl.should.equal '/item/stone_gear'
            display.itemName.should.equal 'Stone Gear'
            display.modSlug.should.equal 'buildcraft'

        it 'assumes an unfound item is from Minecraft', ->
            display = modPack.findItemDisplay 'iron_chestplate'
            display.iconUrl.should.equal '/data/minecraft/1.7.10/images/iron_chestplate.png'
            display.itemUrl.should.equal '/item/iron_chestplate'
            display.itemName.should.equal 'Iron Chestplate'
            display.modSlug.should.equal 'minecraft'
