//
//  DummyData.swift
//  myMood
//
//  Created by Martin Tsang on 2017-09-20.
//  Copyright © 2017 Hirad. All rights reserved.
//

import Foundation


final class DummyData {
    let days:[String] = [
            "About Me Hi! I’m Greta, a Lifestyle and DIY expert. I’m originally from the west coast, and currently living in the Midwest. We’re mad about DIY and travel, lover of fashion and food, and slightly obsessed with trivia. And you can never go wrong with glitter, nail polish or hockey.",
            "Make their Minds Complete, never fill them with doubt. Keep them interested, in all sorts, see them learn fast & grow confident, smart & healthy, in every way.",
            "Birds are chirping, the grass is green, and trees are in full bloom. The warmer weather is here again! Now, it’s time to figure out what you’re going to wear, and work into your wardrobe for the warmer weather. Luckily,",
            "Many people--some of them parents--are not natural conversationalists. They often have no clue where to start, then become easily frustrated by passive-aggressive kids. This article gave some decent convo-launching tips for people--unlike yourself, happily--who have these issues. I think there's some education-privilege showing. I read a narrow-minded worldliness (an irritating dichotomy) in your glib shoot-down of the ar",
            "My husband and I take a different approach. Often, as he walks in the door, he says “how was your day?” and I reply, “it just got better”. It brings a laugh and puts us in a good mood. We’ve been married for 40 years!",
            "Can you feel it coming? I certainly can. It’s the arrival of fall, y’all! Or autumn. Or whatever you call the season of changing leaves and cooler weather. Be ready for the season of the Pumpkin Spice Latte with this super cute, and oh so easy DIY fall decor for the mantel. Sure, this mantel",
            "One of my favorite treats in the summer is a really good glass of lemonade. That tart-sweet taste that’s oh so cold on a hot day is just like heaven. Well, kick up your classic lemonade a notch with this delicious Blueberry Strawberry Lemonade recipe. Made with fresh lemons, strawberries, and blueberries, it’s a real",
            "The ancients took a different line on happiness. As Oliver Burkeman observed in his excellent book The Antidote, the Stoics were particularly keen on being mindful about all the disastrous things that might happen to you – if only to understand that they probably wouldn’t be as bad as you thought. Now instead of Seneca, we have new age gurus who tell us if we think positive thoughts we will float around on a pink clou",
            "We all lose our focus at times. However, keeping your activities aligned with your values is helpful in keeping a positive perspective. One good exercise is to list your values and rank them by their importance to you. Then, see how many of your daily activities actually align with your values. Is there a disconnect? If so, what can you do to change it?",
            "If you are spending your time being busy instead of being focused on the things that make you feel alive, you will find happiness an elusive pursuit. Instead of just being busy, learn to refocus your time so that you are effective, while not wasting time on things that won’t contribute to the best life. After all, you can find many things that take up your time, but don’t take you anywhere.",
            "Would you be able to pause frequently enough to recognize how you feel inside? Gawdat elaborated in a subsequent interview with BI. Even if you don’t know how to fix it yet, recognize that, ‘I’m not feeling OK.",
            "Lost me completely with the last step. Some of us have lost our faith because of what we’ve had to endure. To put it simply, there is no god, there is no plan, there is no “everything happens for a reason”. We’re all just pawns in the biggest, most elaborate cosmic joke ever perpetrated on a species.",
            "Wanting to be happy or joyful all the time is not very realistic, study author Maya Tamir, a psychology professor at The Hebrew University of Jerusalem, told HuffPost. “Never wanting to feel sadness or anger or fear is not realistic. If we are able to accept and even welcome the emotions that we have, whether they are pleasant or unpleasant, we are likely to be happier and more satisfied.",
            "Who is the happier person, the one who decides, “I will be happy when I make 100 million dollars,” or the one who believes, “I will be happy with a great supper and time with my family?” Having lofty goals are great. But when you tie your happiness to future successes that may or may not happen, you never find joy in the life you live today. Find things that thrill you today, and let tomorrow surprise you.",
            "Recent Forum Topics Self-consciousness and social anxiety I’ve been excluded a lot through out my whole life. Now I’m stuck. Marriage Rough Patch Looking for a Community? Money owed by inlaws Problems How to reconnect with dreams? This is a rant, but please feel free to comment, I love to hear what you think. Descartes Square Depression destruction and how to cope with spouse",
            "There is plenty of unhappiness to go around. Why dwell on it? There’s no need, I agree. But we shouldn’t refuse to acknowledge it. TV and the internet disseminate a form of propaganda by insisting on and showcasing shiny, creative, fulfilling lives. It makes me feel inadequate because my life, although creative, and fulfilling and quite well paid, does not send me into paroxysms of ecstasy every day. It is just life, ...",
            "In the study, a group of 38 Northern Californians were split up into two groups — one that took a 90-minute walk in nature and another that did the same walk in the city. The nature walkers reported having fewer negative thoughts about themselves after the walk, while the urban walkers reported no change.",
            "How to answer the ‘Tell me about yourself’ interview question Rather than dread this question, a candidate should welcome this inquiry. Properly answered, this question puts the candidate in the driver's seat. Job interview preparation: What to do before, during, and after an interview Knowing what is expected of you before, during, and after an interview will put you in the best position to prove you’re the best ca",
            "So what’s the lesson here? Next time you buy cocaine… whoops, wrong lesson. Point is, when you make a decision on a goal and then achieve it, you feel better than when good stuff just happens by chance.",
            "To reduce arousal, you need to use just a few words to describe an emotion, and ideally use symbolic language, which means using indirect metaphors, metrics, and simplifications of your experience. This requires you to activate your prefrontal cortex, which reduces the arousal in the limbic system. Here’s the bottom line: describe an emotion in just a word or two, and it helps reduce the emotion.",
            "In fact, as demonstrated in an fMRI experiment, social exclusion activates the same circuitry as physical pain… at one point they stopped sharing, only throwing back and forth to each other, ignoring the participant. This small change was enough to elicit feelings of social exclusion, and it activated the anterior cingulate and insula, just like physical pain would.",
            "Okay, you’re being grateful, labeling negative emotions and making more decisions. Great. But this is feeling kinda lonely for a happiness prescription. Let’s get some other people in here.",
            "Example Sentences for happy For his sake, I am glad once more to be in my own happy home. She left me more composed and happy than I have been for many days. His own situation was described as happy as it could be in a foreign land. When they do not disturb him with earthly medicines, he is quiet and happy. She had rejoiced for his happy spirit, and now she mourned her own widowed lot. In these solitary tours he was busy"
        ]
 
    
    
    //shared instance
    static let shared = DummyData()

    private init(){
       // insertDummyData()
    }
    
    private func insertDummyData() {
        
        var entry:Entry? = nil
        var currentDate:Double = floor(Date().timeIntervalSince1970)
        
        for _ in 0...200 {
            //Set the date
            if arc4random() % 2 == 0 {
                currentDate += 86400
            }
            entry = Entry(date: currentDate, mood: randomMood())
            entry?.entryDescription = randomEntry()
            
            FirebaseDBController.shared.insertEntry(entry: entry!)
        }
        
    }
    
    private func randomEntry() -> String {
        let number:UInt32 = arc4random_uniform(UInt32(days.count))
        return days[Int(number)]
    }
    
    private func randomMood() -> Int {
        var negative:Int = 1
        if arc4random() % 2 == 0 {
            negative = -1
        }
        let mood:Int = Int(arc4random_uniform(11))
        
        return negative * mood
        
    }
    
    
    
    
    
}
