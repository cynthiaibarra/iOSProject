//
//  DrinkQuotes.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/17/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import Foundation

class DrinkQuotes {
    var quotes:[[String:String]]
    
    init() {
        quotes = []
        quotes.append(["author" : "Ernest Hemingway", "quote": "I drink to make other people more interesting."])
        quotes.append(["author" : "Benjamin Frankling", "quote": "In wine there is wisdom, in beer there is freedom, in water there is bacteria."])
        quotes.append(["author" : "Friedrich Nietzsche", "quote": "After the first glass, you see things as you wish they were. After the second, you see things as they are not. Finally, you see things as they really are, and that is the most horrible thing in the world."])
        quotes.append(["author" : "Bette Davis", "quote": "There comes a time in every woman's life when the only thing that helps is a glass of champagne."])
        quotes.append(["author" : "The Simpsons", "quote": "To alcohol! The cause of and solution to all of life's problems."])
        quotes.append(["author" : "Ogden Nash", "quote": "One sip of this will bathe the drooping spirits in delight, beyond the bliss of dreams."])
        quotes.append(["author" : "John Milton", "quote": "Reality is an illusion created by a lack of alcohol."])
        quotes.append(["author" : "Jack Handey", "quote": "Sometimes when I reflect back on all the beer I drink I feel ashamed. Then I look into the glass and think about the workers in the brewery and all of their hopes and dreams. If I didn’t drink this beer, they might be out of work and their dreams would be shattered. Then I say to myself, It is better that I drink this beer and let their dreams come true than to be selfish and worry about my liver."])
        quotes.append(["Frantois Rabelais" : "Ogden Nash", "quote": "When I drink, I think; and when I think, I drink."])
        quotes.append(["author" : "Catherine Zandonella", "quote": "Time is never wasted when you’re wasted all the time."])
        quotes.append(["author" : "Robert Louis Stevenson", "quote": "Wine is bottled poetry."])
        quotes.append(["author" : "Raymond Chandler", "quote": "I think a man ought to get drunk at least twice a year just on principle, so he won't let himself get snotty about it."])
        quotes.append(["author" : "Thomas de Quincy", "quote": "It is most absurdly said, in popular language, of any man, that he is disguised in liquor; for, on the contrary, most men are disguised by sobriety."])
        quotes.append(["author" : "H.L. Mencken", "quote": "he harsh, useful things of the world, from pulling teeth to digging potatoes, are best done by men who are as starkly sober as so many convicts in the death house, but the lovely and useless things, the charming and exhilarating things, are best done by men with, as the phrase is, a few sheets in the wind."])
        quotes.append(["author" : "Dave Barry", "quote": "Without question, the greatest invention in the history of mankind is beer.  Oh, I grant you that the wheel was also a fine invention, but the wheel does not go nearly as well with pizza."])
        quotes.append(["author" : "Galileo", "quote": "Wine is sunlight, held together by water."])

        quotes.append(["author" : "Graham Greene", "quote": "Champagne, if you are seeking the truth, is better than a lie detector.  It encourages a man to be expansive, even reckless, while lie detectors are only a challenge to tell lies successfully."])

        quotes.append(["author" : "The Pogues", "quote": "I am going any which way the wind may be blowing; I am going where streams of whiskey are flowing."])
        quotes.append(["author" : "Ogden Nash", "quote": "Candy is dandy, but liquor is quicker."])
        quotes.append(["author" : "Frank Sinatra", "quote": "I feel bad for people who don’t drink. When they wake up in the morning, that’s as good as they’re going to feel all day."])
        quotes.append(["author" : "Ernest Hemingway", "quote": "Always do sober what you said you’d do drunk. That will teach you to keep your mouth shut."])
        quotes.append(["author" : "Kurt Paradis", "quote": "All is fair in love and beer."])
        quotes.append(["author" : "W.C. Fields", "quote": "I cook with wine, sometimes I even add it to the food."])
        quotes.append(["author" : "Steve Fergosi", "quote": "A drunk man’s words are a sober man’s thoughts."])
        quotes.append(["author" : "Steven Wright", "quote": "24 hours in a day, 24 beers in a case. Coincidence?"])
        quotes.append(["author" : "Benjamin Franklin", "quote": "Beer is proof that God loves us and wants us to be happy."])
        quotes.append(["author" : "Tommy Cooper", "quote": "I’m on a whisky diet. I’ve lost three days already."])
        quotes.append(["author" : "Homer Simpson", "quote": "Alcohol is a way of life, alcohol is my way of life, and I aim to keep it."])
        quotes.append(["author" : "Dean Martin", "quote": "If you drink, don’t drive. Don’t even putt."])
        quotes.append(["author" : "Compton Mackenzie", "quote": "Love makes the world go round? Not at all. Whiskey makes it go round twice as fast."])
        quotes.append(["author" : "Kurt Paradis", "quote": "I drink too much. The last time I gave a urine sample it had an olive in it."])
        quotes.append(["author" : "Rodney Dangerfield", "quote": "All is fair in love and beer."])
        quotes.append(["author" : "Benjamin Franklin", "quote": "He that drinks fast, pays slow.”"])
        quotes.append(["author" : "George Bernard Shaw", "quote": "Whisky is liquid sunshine."])
        quotes.append(["author" : "Frank Sinatra", "quote": "Alcohol may be man’s worst enemy, but the bible says love your enemy."])
        quotes.append(["author" : "F. Scott Fitzgerald", "quote": "First you take a drink, then the drink takes a drink, then the drink takes you."])
        quotes.append(["author" : "Winston S. Churchill", "quote": "A lady came up to me one day and said ‘Sir! You are drunk’, to which I replied ‘I am drunk today madam, and tomorrow I shall be sober, but you will still be ugly."])
        quotes.append(["author" : "Ernest Hemingway", "quote": "An intelligent man is sometimes forced to be drunk to spend time with his fools."])
        quotes.append(["author" : "Louis Pasteur", "quote": "Wine is the most healthful and most hygienic of beverages."])
        quotes.append(["author" : "Raymond Chandler", "quote": "There is no bad whiskey. There are only some whiskeys that aren’t as good as others."])
    
    }
    
    func returnQuote() -> ([String:String]) {
        let index:Int = Int(arc4random_uniform(UInt32(quotes.count)))
        return quotes[index];
    }
    
}
