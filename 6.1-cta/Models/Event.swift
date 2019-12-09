//
//  Event.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/2/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import Foundation

// MARK: - Event
struct Event: Codable {
    let embedded: EventEmbedded
    
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }

    static func getEvents(from jsonData: Data) throws -> [EventElement]? {
        let response = try JSONDecoder().decode(Event.self, from: jsonData)
        
        
        return response.embedded.events
    }

    
}

// MARK: - EventEmbedded
struct EventEmbedded: Codable {
    let events: [EventElement]
    
    
}

// MARK: - EventElement
struct EventElement: Codable {
    let name: String
    let images: [Image]
    let dates: Dates
    let id: String
    
    func existsInFavorites(completion: @escaping (Result<Bool,Error>) -> ()) {
        
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        
        FirestoreService.manager.getEvents(forUserID: user.uid) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                print(error)
            case .success(let events):
                if events.contains(where: {$0.id == self.id}) {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
    }
}

// MARK: - Dates
struct Dates: Codable {
    let start: Start
}

// MARK: - Start
struct Start: Codable {
    let localDate, localTime: String
    let dateTime: String
}

// MARK: - Image
struct Image: Codable {
    let ratio: String
    let url: String
    let width, height: Int
}

/**
 {
     "name": "Eagles",
     "type": "event",
     "id": "G5diZ4Vr8MoPK",
     "test": false,
     "url": "https://www.ticketmaster.com/eagles-new-york-new-york-02-14-2020/event/3B00574790DD1953",
     "locale": "en-us",
     "images": [
         {
             "ratio": "4_3",
             "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_CUSTOM.jpg",
             "width": 305,
             "height": 225,
             "fallback": false
         },
         {
             "ratio": "16_9",
             "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_TABLET_LANDSCAPE_16_9.jpg",
             "width": 1024,
             "height": 576,
             "fallback": false
         },
         {
             "ratio": "3_2",
             "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_RETINA_PORTRAIT_3_2.jpg",
             "width": 640,
             "height": 427,
             "fallback": false
         },
         {
             "ratio": "16_9",
             "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_EVENT_DETAIL_PAGE_16_9.jpg",
             "width": 205,
             "height": 115,
             "fallback": false
         },
         {
             "ratio": "3_2",
             "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_TABLET_LANDSCAPE_3_2.jpg",
             "width": 1024,
             "height": 683,
             "fallback": false
         },
         {
             "ratio": "16_9",
             "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_TABLET_LANDSCAPE_LARGE_16_9.jpg",
             "width": 2048,
             "height": 1152,
             "fallback": false
         },
         {
             "ratio": "16_9",
             "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_RETINA_PORTRAIT_16_9.jpg",
             "width": 640,
             "height": 360,
             "fallback": false
         },
         {
             "ratio": "16_9",
             "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_RECOMENDATION_16_9.jpg",
             "width": 100,
             "height": 56,
             "fallback": false
         },
         {
             "ratio": "3_2",
             "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_ARTIST_PAGE_3_2.jpg",
             "width": 305,
             "height": 203,
             "fallback": false
         },
         {
             "ratio": "16_9",
             "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_RETINA_LANDSCAPE_16_9.jpg",
             "width": 1136,
             "height": 639,
             "fallback": false
         }
     ],
     "sales": {
         "public": {
             "startDateTime": "2019-10-18T14:00:00Z",
             "startTBD": false,
             "endDateTime": "2020-02-15T01:00:00Z"
         },
         "presales": [
             {
                 "startDateTime": "2019-10-14T14:00:00Z",
                 "endDateTime": "2020-02-15T01:00:00Z",
                 "name": "Official Platinum"
             },
             {
                 "startDateTime": "2019-10-14T14:00:00Z",
                 "endDateTime": "2019-10-18T02:00:00Z",
                 "name": "American Express® Card Member Presale"
             },
             {
                 "startDateTime": "2019-10-17T14:00:00Z",
                 "endDateTime": "2019-10-18T02:00:00Z",
                 "name": "Local Presales"
             },
             {
                 "startDateTime": "2019-10-17T14:00:00Z",
                 "endDateTime": "2019-10-18T02:00:00Z",
                 "name": "Live Nation Presale"
             },
             {
                 "startDateTime": "2019-10-17T14:00:00Z",
                 "endDateTime": "2019-10-18T02:00:00Z",
                 "name": "Live Nation Mobile App Presale",
                 "description": "Download the Live Nation iPhone App now to access Live Nation Mobile App Presales. Browse, search, and discover concerts for your favorite artists near you; get alerts on presales, onsales, and last minute tickets; and easily and quickly purchase tickets while in the app. Check out set lists on the go, check in with your friends, view your ticket info, seating charts, exclusive photos, videos and more…",
                 "url": "http://promo.livenation.com/iphone/"
             }
         ]
     },
     "dates": {
         "start": {
             "localDate": "2020-02-14",
             "localTime": "20:00:00",
             "dateTime": "2020-02-15T01:00:00Z",
             "dateTBD": false,
             "dateTBA": false,
             "timeTBA": false,
             "noSpecificTime": false
         },
         "timezone": "America/New_York",
         "status": {
             "code": "onsale"
         },
         "spanMultipleDays": false
     },
     "classifications": [
         {
             "primary": true,
             "segment": {
                 "id": "KZFzniwnSyZfZ7v7nJ",
                 "name": "Music"
             },
             "genre": {
                 "id": "KnvZfZ7vAeA",
                 "name": "Rock"
             },
             "subGenre": {
                 "id": "KZazBEonSMnZfZ7v6F1",
                 "name": "Pop"
             },
             "type": {
                 "id": "KZAyXgnZfZ7v7nI",
                 "name": "Undefined"
             },
             "subType": {
                 "id": "KZFzBErXgnZfZ7v7lJ",
                 "name": "Undefined"
             },
             "family": false
         }
     ],
     "promoter": {
         "id": "494",
         "name": "PROMOTED BY VENUE",
         "description": "PROMOTED BY VENUE / NTL / USA"
     },
     "promoters": [
         {
             "id": "494",
             "name": "PROMOTED BY VENUE",
             "description": "PROMOTED BY VENUE / NTL / USA"
         },
         {
             "id": "4018",
             "name": "LIVE NATION - NO LN CONCERTS BRANDING",
             "description": "LIVE NATION - NO LN CONCERTS BRANDING / NTL / USA"
         }
     ],
     "info": "To allow for more Card Members to enjoy the show, American Express has set a two-order limit for this offer. This limit applies across all Cards associated with all of your American Express accounts. Prepaid Cards are not eligible.",
     "pleaseNote": "To allow for more Card Members to enjoy the show, American Express has set a two-order limit for this offer. This limit applies across all Cards associated with all of your American Express accounts. Prepaid Cards are not eligible. Tickets are not available at the box office on the first day of the public on sale. ARRIVE EARLY: Please arrive one-hour prior to showtime. All packages, including briefcases and pocketbooks, will be inspected prior to entry.",
     "priceRanges": [
         {
             "type": "standard",
             "currency": "USD",
             "min": 129.0,
             "max": 750.0
         }
     ],
     "products": [
         {
             "id": "G5diZ4ViZHKwL",
             "url": "https://www.ticketmaster.com/hotel-california-tour-laneone-upgrade-package-new-york-new-york-02-14-2020/event/3B00574B00F13C9F",
             "type": "VIP",
             "name": "Hotel California Tour - LaneOne Upgrade Package (Ticket Not Included)"
         }
     ],
     "ticketLimit": {
         "info": "There is an eight (8) ticket limit for this event."
     },
     "_links": {
         "self": {
             "href": "/discovery/v2/events/G5diZ4Vr8MoPK?locale=en-us"
         },
         "attractions": [
             {
                 "href": "/discovery/v2/attractions/K8vZ9171ob7?locale=en-us"
             }
         ],
         "venues": [
             {
                 "href": "/discovery/v2/venues/KovZpZA7AAEA?locale=en-us"
             }
         ]
     },
     "_embedded": {
         "venues": [
             {
                 "name": "Madison Square Garden",
                 "type": "venue",
                 "id": "KovZpZA7AAEA",
                 "test": false,
                 "url": "https://www.ticketmaster.com/madison-square-garden-tickets-new-york/venue/483329",
                 "locale": "en-us",
                 "aliases": [
                     "msg",
                     "madison square garden"
                 ],
                 "images": [
                     {
                         "ratio": "3_1",
                         "url": "https://s1.ticketm.net/dam/v/07f/63babc6f-de0c-4822-bde3-0bbdd9c4607f_379261_SOURCE.jpg",
                         "width": 1500,
                         "height": 500,
                         "fallback": false
                     },
                     {
                         "ratio": "16_9",
                         "url": "https://s1.ticketm.net/dbimages/15646v.jpg",
                         "width": 205,
                         "height": 115,
                         "fallback": false
                     }
                 ],
                 "postalCode": "10001",
                 "timezone": "America/New_York",
                 "city": {
                     "name": "New York"
                 },
                 "state": {
                     "name": "New York",
                     "stateCode": "NY"
                 },
                 "country": {
                     "name": "United States Of America",
                     "countryCode": "US"
                 },
                 "address": {
                     "line1": "7th Ave & 32nd Street"
                 },
                 "location": {
                     "longitude": "-73.9916006",
                     "latitude": "40.7497062"
                 },
                 "markets": [
                     {
                         "name": "New York/Tri-State Area",
                         "id": "35"
                     },
                     {
                         "name": "All of US",
                         "id": "51"
                     },
                     {
                         "name": "Northern New Jersey",
                         "id": "55"
                     },
                     {
                         "name": "Connecticut",
                         "id": "124"
                     }
                 ],
                 "dmas": [
                     {
                         "id": 200
                     },
                     {
                         "id": 296
                     },
                     {
                         "id": 345
                     },
                     {
                         "id": 422
                     }
                 ],
                 "social": {
                     "twitter": {
                         "handle": "@TheGarden"
                     }
                 },
                 "boxOfficeInfo": {
                     "phoneNumberDetail": "General Info: (212) 465-MSG1 (6741) or (212) 247-4777 Knicks Information: 1(877) NYK-DUNK. Rangers Fan Line: (212) 465-4459. Liberty Hotline: (212) 564-WNBA (9622). Season Subscriptions: (212) 465-6073. Disabled Services: (212) 465-6034 Guest Relations: (212) 465 - 6225 Group Sales: (212) 465-6100 Lost and Found: (212) 465-6299",
                     "openHoursDetail": "Monday - Saturday: 10:00am to 6:00pm **Tickets are not on-sale at the Box Office on the first day an event goes on-sale** The Box Office will be open at 10:00am daily or 90 minutes before the 1st performance of the day, whichever is earlier and will stay open until 8:00pm or 30 minutes after the last performance of the day begins, whichever is later. Sunday – Closed If an event takes place on Sunday, Box Office will open 90 minutes before the event start time and remain open 1 hour after event start time for Will Call and tickets sales for the evening's event only.",
                     "acceptedPaymentDetail": "Cash, American Express, Visa, MasterCard, Discover. ATM machines are located in Chase Square.",
                     "willCallDetail": "Pick-up tickets anytime the day of the show during box office hours (see above). Customers must present the actual credit card used to place the order and a picture ID. MSG cannot accept third party or “drop offs” from individual patrons."
                 },
                 "parkingDetail": "Prepaid advance parking is available for select events through Ticketmaster or via a link on www.thegarden.com. Madison Square Garden does not own or operate any parking facility.",
                 "accessibleSeatingDetail": "MSG WHEELCHAIR AND TRANSFER SEATING POLICY: Wheelchair and Transfer seating is reserved exclusively for patrons with accessible needs and their companions. Accessible seating is intended for use by an individual with a mobility disability or other disability who requires the accessible features of accessible seating due to a disability, and that individual's companions. Madison Square Garden (MSG) reserves the right to investigate potential misuse of accessible seating and to take all appropriate action against individuals who fraudulently obtain tickets for accessible seating. While tickets for accessible seating legitimately purchased for the use of an individual with disability may be transferred to another individual under the same terms and conditions applicable to other tickets, in the event such ticket is transferred to a non-disabled individual, MSG reserves the right to transfer that individual to other available seating TO ORDER WHEELCHAIR AND TRANSFER SEATING: Tickets for people with accessible needs, subject to availability, may be purchased in several ways: 1) Call Ticketmaster at 866-858-0008 2) Call MSG's Disabled Services Department at (212)465-6115. 3) Visit Madison Square Garden's Box Office (see box office hours above) 4) Order Online with Ticketmaster (select your event from the list to the left) For additional information regarding accessibility at Madison Square Garden or to request any other accommodations, please call MSG's Disabled Services Department at (212) 465-6115 any weekday between 9:30am-4:30pm ET. Service Animals Pets are not permitted at Madison Square Garden. MSG has very specific policies related to service and emotional support animals. Please visit www.thegarden.com to obtain more information for admitting your animal. Assistive listening devices (ALDAs) are available upon request. Please visit the Guest Experience Office across from section 117 for assistance. There is no charge for this service, however some form of identification will be requested and returned to you, once the device is checked back in. Wheelchair Storage: For patrons who wish to transfer to a seat from their wheelchair, we will store your mobility device at the Guest Experience Office. You will receive a claim check for your device. Wheelchair Escorts to Seats: Patrons with mobility impairments who do not have access to a wheelchair may request a wheelchair to transport the individual to/from their seat, free of charge. Please be aware that our personnel cannot remain with you during the event, nor will they allow you to remain in or keep the wheelchair for the duration of the event. In the event a patron requires the use of a wheelchair for the duration of the event, we recommend bringing your own wheelchair or other mobility device. The escort pick-up area is located on the South (toward 31st) side of Chase Square at elevator alcove. Please allow for extra so that you may be accommodated prior to the event start. Simply ask a Guest Experience Representative or a MSG Security Guard for assistance. Elevators: Public elevators are available for use by guests with disabilities and service every seating level",
                 "generalInfo": {
                     "generalRule": "ARRIVE EARLY: Please arrive at least one-hour prior to event time. All patrons will go through a screening process upon entry with all packages, including briefcases and pocketbooks, being inspected prior to entry. Additionally, metal detectors may be utilized for some events. Bags that have passed inspection must fit comfortably under your seat.Please be mindful of traffic conditions, as Midtown Manhattan can be quite congested, especially during the holidays, parades, or special events. No smoking or electronic cigarettes permitted anywhere in the building No reentry. No recording devices No outside food or drink There are no bag or coat check facilities Alcohol Management: For most events at MSG, alcoholic beverages are available for purchase. MSG staff is trained in the nationally recognized T.E.A.M. (Techniques for Effective Alcohol Management) training program for responsible alcohol management. All guests will be required to show ID to purchase alcohol. Guests are not permitted to bring in alcoholic beverages from outside and may not leave with alcohol purchased inside the venue. Management reserves the right to refuse the sale of alcohol to any guest. Please be aware that it is the policy of The Madison Square Garden Company to require all guests who appear to be forty (40) years of age or younger to present a valid form of ID with proof of age in order to purchase alcoholic beverages at Madison Square Garden, Radio City Music Hall, The Beacon Theatre or The Chicago Theatre. Pursuant to applicable State law, MSG accepts only the following forms of identification: • A valid driver’s license or non-driver identification card issued by the United States Government, a State Government, Commonwealth, Possession or Territory of the United States or a Provincial Government of Canada. • A valid passport • A valid U.S. military ID International guests wishing to consume alcohol inside the building must bring a valid passport as the only form of acceptable ID.",
                     "childRule": "For most events, all children who have reached their second birthday require a ticket to gain admittance to Madison Square Garden. Any child who has yet to reach their second birthday does not require a ticket, however, they may not occupy their own seat. Please note, that for certain children's events (such as the Wiggles and Sesame Street Live!), all children who have reached their first birthday require a ticket. Please check the event profile for your specific event for more information prior to your purchase of tickets."
                 },
                 "upcomingEvents": {
                     "_total": 528,
                     "tmr": 8,
                     "ticketmaster": 520
                 },
                 "ada": {
                     "adaPhones": "Inquiries or requests concerning accessibility should be directed to the Accessible Services Department for Madison Square Garden at 888-609-7599.",
                     "adaCustomCopy": "Individuals with disabilities may purchase up to three seats for companions in the wheelchair or other accessible seating areas, provided such seats are available.  Additional tickets, if available, may be purchased as close to the accessible seating areas, as long as it does not exceed the ticket limit for the event.  Please note, for events or specific seating sections where ticket sales are limited to fewer than four tickets per patron, the same ticket restrictions will apply to the purchase of accessible seating.\n\nAccessible seating is intended for use by an individual with a mobility disability or other disability who requires the accessible features of accessible seating due to a disability, and that individual's companions.  Madison Square Garden reserves the right to investigate potential misuse of accessible seating and to take all appropriate action against individuals who fraudulently obtain tickets for accessible seating.  While tickets for accessible seating legitimately purchased for the use of an individual with disability may be transferred to another individual under the same terms and conditions applicable to other tickets, in the event such ticket is transferred to a nondisabled individual, Madison Square Garden reserves the right to transfer that individual to other available seating.\n\nIf the disabled individual cannot attend an event for which he/she has purchased tickets, please contact the Madison Square Garden Disabled Services Department at 212-465-6034 prior to the event taking place for further information. \n\nTickets for individuals with accessible needs, subject to availability, may be purchased in several ways:\n\n1) Online through Ticketmaster.com\n2) By phone to the Disabled Services Department at 888-609-7599\n3) By phone to Ticketmaster at 800-745-3000\n4) In-person by visiting the Madison Square Garden Box Office\n\nAssistive Listening Devices (ALD) are available at Guest Experience locations in the Arena. \n",
                     "adaHours": "For additional information regarding Access at Madison Square Garden or to discuss any other accommodations, please contact the Disabled Services Department at 888-609-7599 between the hours of 9:30am and 4:30pm, Monday â€“ Friday. "
                 },
                 "_links": {
                     "self": {
                         "href": "/discovery/v2/venues/KovZpZA7AAEA?locale=en-us"
                     }
                 }
             }
         ],
         "attractions": [
             {
                 "name": "Eagles",
                 "type": "attraction",
                 "id": "K8vZ9171ob7",
                 "test": false,
                 "url": "https://www.ticketmaster.com/eagles-tickets/artist/734977",
                 "locale": "en-us",
                 "externalLinks": {
                     "twitter": [
                         {
                             "url": "https://twitter.com/TheEaglesBand"
                         }
                     ],
                     "itunes": [
                         {
                             "url": "https://itunes.apple.com/artist/id1053549"
                         }
                     ],
                     "lastfm": [
                         {
                             "url": "https://www.last.fm/music/Eagles"
                         }
                     ],
                     "wiki": [
                         {
                             "url": "https://en.wikipedia.org/wiki/Eagles_(band)"
                         }
                     ],
                     "facebook": [
                         {
                             "url": "https://www.facebook.com/EaglesBand"
                         }
                     ],
                     "musicbrainz": [
                         {
                             "id": "f46bd570-5768-462e-b84c-c7c993bbf47e"
                         }
                     ],
                     "homepage": [
                         {
                             "url": "https://eagles.com/"
                         }
                     ]
                 },
                 "images": [
                     {
                         "ratio": "4_3",
                         "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_CUSTOM.jpg",
                         "width": 305,
                         "height": 225,
                         "fallback": false
                     },
                     {
                         "ratio": "16_9",
                         "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_TABLET_LANDSCAPE_16_9.jpg",
                         "width": 1024,
                         "height": 576,
                         "fallback": false
                     },
                     {
                         "ratio": "3_2",
                         "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_RETINA_PORTRAIT_3_2.jpg",
                         "width": 640,
                         "height": 427,
                         "fallback": false
                     },
                     {
                         "ratio": "16_9",
                         "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_EVENT_DETAIL_PAGE_16_9.jpg",
                         "width": 205,
                         "height": 115,
                         "fallback": false
                     },
                     {
                         "ratio": "3_2",
                         "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_TABLET_LANDSCAPE_3_2.jpg",
                         "width": 1024,
                         "height": 683,
                         "fallback": false
                     },
                     {
                         "ratio": "16_9",
                         "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_TABLET_LANDSCAPE_LARGE_16_9.jpg",
                         "width": 2048,
                         "height": 1152,
                         "fallback": false
                     },
                     {
                         "ratio": "16_9",
                         "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_RETINA_PORTRAIT_16_9.jpg",
                         "width": 640,
                         "height": 360,
                         "fallback": false
                     },
                     {
                         "ratio": "16_9",
                         "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_RECOMENDATION_16_9.jpg",
                         "width": 100,
                         "height": 56,
                         "fallback": false
                     },
                     {
                         "ratio": "3_2",
                         "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_ARTIST_PAGE_3_2.jpg",
                         "width": 305,
                         "height": 203,
                         "fallback": false
                     },
                     {
                         "ratio": "16_9",
                         "url": "https://s1.ticketm.net/dam/a/c40/e0f4dedd-b435-4b8b-8fd0-e73e47e93c40_851341_RETINA_LANDSCAPE_16_9.jpg",
                         "width": 1136,
                         "height": 639,
                         "fallback": false
                     }
                 ],
                 "classifications": [
                     {
                         "primary": true,
                         "segment": {
                             "id": "KZFzniwnSyZfZ7v7nJ",
                             "name": "Music"
                         },
                         "genre": {
                             "id": "KnvZfZ7vAeA",
                             "name": "Rock"
                         },
                         "subGenre": {
                             "id": "KZazBEonSMnZfZ7v6F1",
                             "name": "Pop"
                         },
                         "type": {
                             "id": "KZAyXgnZfZ7v7nI",
                             "name": "Undefined"
                         },
                         "subType": {
                             "id": "KZFzBErXgnZfZ7v7lJ",
                             "name": "Undefined"
                         },
                         "family": false
                     }
                 ],
                 "upcomingEvents": {
                     "_total": 24,
                     "tmr": 2,
                     "ticketmaster": 22
                 },
                 "_links": {
                     "self": {
                         "href": "/discovery/v2/attractions/K8vZ9171ob7?locale=en-us"
                     }
                 }
             }
         ]
     }
 }
 */
