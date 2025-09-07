#!/bin/bash

rails g model Round  number:integer time:time board:string tournament:belongs_to
rails g model Room   name:string tournament:belongs_to
rails g model Table  number:integer room:belongs_to
rails g model Game   table:belongs_to round:belongs_to
rails g model Result generations:integer game:belongs_to
rails g model Seat   number:integer game:belongs_to participation:belongs_to
rails g model Score  corporation:string points:integer rank:integer seat:belongs_to
