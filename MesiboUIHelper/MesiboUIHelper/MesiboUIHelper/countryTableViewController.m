/** Copyright (c) 2019 Mesibo
 * https://mesibo.com
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the terms and condition mentioned
 * on https://mesibo.com as well as following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions, the following disclaimer and links to documentation and
 * source code repository.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * Neither the name of Mesibo nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific prior
 * written permission.
 *
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * Documentation
 * https://mesibo.com/documentation/
 *
 * Source Code Repository
 * https://github.com/mesibo/ui-modules-ios
 *
 */

#import "countryTableViewController.h"
#import "registerMobileViewController.h"
#import "MesiboUIHelper.h"

@interface countryTableViewController () <UISearchControllerDelegate,UISearchResultsUpdating>
@property (nonatomic, strong) UISearchController * searchController;
@property (strong, nonatomic) IBOutlet UITableView *mCountryTable;

@end

@implementation countryTableViewController  {


    UITableView *sa;
    BOOL isSearching;


}


NSDictionary *countryList ;
NSArray *keys ;
NSString *sigDent ;
NSArray *countries;
NSArray *countryCC;
NSArray *countryCode;
//NSArray *searchResults;
NSDictionary *searchIndex;
NSDictionary *dataD;
BOOL mIsSearching ;
NSMutableArray *mSearchResults;

@synthesize rateFinder;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mSearchResults = [[NSMutableArray alloc] init];

    //mSearchResults = [[NSMutableArray alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationController.navigationBar.translucent = NO;
    countries =
    [NSArray  arrayWithObjects:@"Afghanistan"
    , @"Aland Islands"
    , @"Albania"
    , @"Algeria"
    , @"American Samoa"
    , @"Andorra"
    , @"Angola"
    , @"Anguilla"
    , @"Antarctica"
    , @"Antigua and Barbuda"
    , @"Argentina"
    , @"Armenia"
    , @"Aruba"
    , @"Australia"
    , @"Austria"
    , @"Azerbaijan"
    , @"Bahamas"
    , @"Bahrain"
    , @"Bangladesh"
    , @"Barbados"
    , @"Belarus"
    , @"Belgium"
    , @"Belize"
    , @"Benin"
    , @"Bermuda"
    , @"Bhutan"
    , @"Bolivia"
    , @"Bosnia and Herzegovina"
    , @"Botswana"
    , @"Bouvet Island"
    , @"BQ"
    , @"Brazil"
    , @"British Indian Ocean Territory"
    , @"British Virgin Islands"
    , @"Brunei Darussalam"
    , @"Bulgaria"
    , @"Burkina Faso"
    , @"Burundi"
    , @"Cambodia"
    , @"Cameroon"
    , @"Canada"
    , @"Cape Verde"
    , @"Cayman Islands"
    , @"Central African Republic"
    , @"Chad"
    , @"Chile"
    , @"China"
    , @"Christmas Island"
    , @"Cocos (Keeling) Islands"
    , @"Colombia"
    , @"Comoros"
    , @"Congo (Brazzaville)"
    , @"Congo, Democratic Republic of the"
    , @"Cook Islands"
    , @"Costa Rica"
    , @"Côte d'Ivoire"
    , @"Croatia"
    , @"Cuba"
    , @"Curacao"
    , @"Cyprus"
    , @"Czech Republic"
    , @"Denmark"
    , @"Djibouti"
    , @"Dominica"
    , @"Dominican Republic"
    , @"Ecuador"
    , @"Egypt"
    , @"El Salvador"
    , @"Equatorial Guinea"
    , @"Eritrea"
    , @"Estonia"
    , @"Ethiopia"
    , @"Falkland Islands (Malvinas)"
    , @"Faroe Islands"
    , @"Fiji"
    , @"Finland"
    , @"France"
    , @"French Guiana"
    , @"French Polynesia"
    , @"French Southern Territories"
    , @"Gabon"
    , @"Gambia"
    , @"Georgia"
    , @"Germany"
    , @"Ghana"
    , @"Gibraltar"
    , @"Greece"
    , @"Greenland"
    , @"Grenada"
    , @"Guadeloupe"
    , @"Guam"
    , @"Guatemala"
    , @"Guernsey"
    , @"Guinea"
    , @"Guinea-Bissau"
    , @"Guyana"
    , @"Haiti"
    , @"Holy See (Vatican City State)"
    , @"Honduras"
    , @"Hong Kong, Special Administrative Region of China"
    , @"Hungary"
    , @"Iceland"
    , @"India"
    , @"Indonesia"
    , @"Iran, Islamic Republic of"
    , @"Iraq"
    , @"Ireland"
    , @"Isle of Man"
    , @"Israel"
    , @"Italy"
    , @"Jamaica"
    , @"Japan"
    , @"Jersey"
    , @"Jordan"
    , @"Kazakhstan"
    , @"Kenya"
    , @"Kiribati"
    , @"Korea, Democratic People's Republic of"
    , @"Korea, Republic of"
    , @"Kuwait"
    , @"Kyrgyzstan"
    , @"Lao PDR"
    , @"Latvia"
    , @"Lebanon"
    , @"Lesotho"
    , @"Liberia"
    , @"Libya"
    , @"Liechtenstein"
    , @"Lithuania"
    , @"Luxembourg"
    , @"Macao, Special Administrative Region of China"
    , @"Macedonia, Republic of"
    , @"Madagascar"
    , @"Malawi"
    , @"Malaysia"
    , @"Maldives"
    , @"Mali"
    , @"Malta"
    , @"Marshall Islands"
    , @"Martinique"
    , @"Mauritania"
    , @"Mauritius"
    , @"Mayotte"
    , @"Mexico"
    , @"Micronesia, Federated States of"
    , @"Moldova"
    , @"Monaco"
    , @"Mongolia"
    , @"Montenegro"
    , @"Montserrat"
    , @"Morocco"
    , @"Mozambique"
    , @"Myanmar"
    , @"Namibia"
    , @"Nauru"
    , @"Nepal"
    , @"Netherlands"
    , @"Netherlands Antilles"
    , @"New Caledonia"
    , @"New Zealand"
    , @"Nicaragua"
    , @"Niger"
    , @"Nigeria"
    , @"Niue"
    , @"Norfolk Island"
    , @"Northern Mariana Islands"
    , @"Norway"
    , @"Oman"
    , @"Pakistan"
    , @"Palau"
    , @"Palestinian Territory, Occupied"
    , @"Panama"
    , @"Papua New Guinea"
    , @"Paraguay"
    , @"Peru"
    , @"Philippines"
    , @"Pitcairn"
    , @"Poland"
    , @"Portugal"
    , @"Puerto Rico"
    , @"Qatar"
    , @"Réunion"
    , @"Romania"
    , @"Russian Federation"
    , @"Rwanda"
    , @"Saint Helena"
    , @"Saint Kitts and Nevis"
    , @"Saint Lucia"
    , @"Saint Pierre and Miquelon"
    , @"Saint Vincent and Grenadines"
    , @"Saint-Barthélemy"
    , @"Saint-Martin (French part)"
    , @"Samoa"
    , @"San Marino"
    , @"Sao Tome and Principe"
    , @"Saudi Arabia"
    , @"Senegal"
    , @"Serbia"
    , @"Seychelles"
    , @"Sierra Leone"
    , @"Singapore"
    , @"Sint Maarten"
    , @"Slovakia"
    , @"Slovenia"
    , @"Solomon Islands"
    , @"Somalia"
    , @"South Africa"
    , @"South Georgia and the South Sandwich Islands"
    , @"South Sudan"
    , @"Spain"
    , @"Sri Lanka"
    , @"Sudan"
    , @"Suriname"
    , @"Svalbard and Jan Mayen Islands"
    , @"Swaziland"
    , @"Sweden"
    , @"Switzerland"
    , @"Syrian Arab Republic (Syria)"
    , @"Taiwan, Republic of China"
    , @"Tajikistan"
    , @"Tanzania, United Republic of"
    , @"Thailand"
    , @"Timor-Leste"
    , @"Togo"
    , @"Tokelau"
    , @"Tonga"
    , @"Trinidad and Tobago"
    , @"Tunisia"
    , @"Turkey"
    , @"Turkmenistan"
    , @"Turks and Caicos Islands"
    , @"Tuvalu"
    , @"Uganda"
    , @"Ukraine"
    , @"United Arab Emirates"
    , @"United Kingdom"
    , @"United States of America"
    , @"Uruguay"
    , @"Uzbekistan"
    , @"Vanuatu"
    , @"Venezuela (Bolivarian Republic of)"
    , @"Viet Nam"
    , @"Virgin Islands, US"
    , @"Wallis and Futuna Islands"
    , @"Western Sahara"
    , @"Yemen"
    , @"Zambia"
    , @"Zimbabwe" ,nil];
    
    countryCC = [NSArray arrayWithObjects:@"93",@"358",@"355",@"213",@"1",@"376",@"244",@"1",@"672",@"1",@"54",@"374",@"297",@"61",@"43",@"994",@"1",@"973",@"880",@"1",@"375",@"32",@"501",@"229",@"1",@"975",@"591",@"387",@"267",@"47",@"599",@"55",@"246",@"1",@"673",@"359",@"226",@"257",@"855",@"237",@"1",@"238",@"345",@"236",@"235",@"56",@"86",@"61",@"61",@"57",@"269",@"242",@"243",@"682",@"506",@"225",@"385",@"53",@"599",@"537",@"420",@"45",@"253",@"1",@"1",@"593",@"20",@"503",@"240",@"291",@"372",@"251",@"500",@"298",@"679",@"358",@"33",@"594",@"689",@"689",@"241",@"220",@"995",@"49",@"233",@"350",@"30",@"299",@"1",@"590",@"1",@"502",@"44",@"224",@"245",@"595",@"509",@"379",@"504",@"852",@"36",@"354",@"91",@"62",@"98",@"964",@"353",@"44",@"972",@"39",@"1",@"81",@"44",@"962",@"77",@"254",@"686",@"850",@"82",@"965",@"996",@"856",@"371",@"961",@"266",@"231",@"218",@"423",@"370",@"352",@"853",@"389",@"261",@"265",@"60",@"960",@"223",@"356",@"692",@"596",@"222",@"230",@"262",@"52",@"691",@"373",@"377",@"976",@"382",@"1",@"212",@"258",@"95",@"264",@"674",@"977",@"31",@"599",@"687",@"64",@"505",@"227",@"234",@"683",@"672",@"1",@"47",@"968",@"92",@"680",@"970",@"507",@"675",@"595",@"51",@"63",@"872",@"48",@"351",@"1",@"974",@"262",@"40",@"7",@"250",@"290",@"1",@"1",@"508",@"1",@"590",@"590",@"685",@"378",@"239",@"966",@"221",@"381",@"248",@"232",@"65",@"1",@"421",@"386",@"677",@"252",@"27",@"500",@"211",@"34",@"94",@"249",@"597",@"47",@"268",@"46",@"41",@"963",@"886",@"992",@"255",@"66",@"670",@"228",@"690",@"676",@"1",@"216",@"90",@"993",@"1",@"688",@"256",@"380",@"971",@"44",@"1",@"598",@"998",@"678",@"58",@"84",@"1",@"681",@"212",@"967",@"260",@"263", nil];
    
    countryCode = [NSArray arrayWithObjects:@"AF",@"AX",@"AL",@"DZ",@"AS",@"AD",@"AO",@"AI",@"AQ",@"AG",@"AR",@"AM",@"AW",@"AU",@"AT",@"AZ",@"BS",@"BH",@"BD",@"BB",@"BY",@"BE",@"BZ",@"BJ",@"BM",@"BT",@"BO",@"BA",@"BW",@"BV",@"BQ",@"BR",@"IO",@"VG",@"BN",@"BG",@"BF",@"BI",@"KH",@"CM",@"CA",@"CV",@"KY",@"CF",@"TD",@"CL",@"CN",@"CX",@"CC",@"CO",@"KM",@"CG",@"CD",@"CK",@"CR",@"CI",@"HR",@"CU",@"CW",@"CY",@"CZ",@"DK",@"DJ",@"DM",@"DO",@"EC",@"EG",@"SV",@"GQ",@"ER",@"EE",@"ET",@"FK",@"FO",@"FJ",@"FI",@"FR",@"GF",@"PF",@"TF",@"GA",@"GM",@"GE",@"DE",@"GH",@"GI",@"GR",@"GL",@"GD",@"GP",@"GU",@"GT",@"GG",@"GN",@"GW",@"GY",@"HT",@"VA",@"HN",@"HK",@"HU",@"IS",@"IN",@"ID",@"IR",@"IQ",@"IE",@"IM",@"IL",@"IT",@"JM",@"JP",@"JE",@"JO",@"KZ",@"KE",@"KI",@"KP",@"KR",@"KW",@"KG",@"LA",@"LV",@"LB",@"LS",@"LR",@"LY",@"LI",@"LT",@"LU",@"MO",@"MK",@"MG",@"MW",@"MY",@"MV",@"ML",@"MT",@"MH",@"MQ",@"MR",@"MU",@"YT",@"MX",@"FM",@"MD",@"MC",@"MN",@"ME",@"MS",@"MA",@"MZ",@"MM",@"NA",@"NR",@"NP",@"NL",@"AN",@"NC",@"NZ",@"NI",@"NE",@"NG",@"NU",@"NF",@"MP",@"NO",@"OM",@"PK",@"PW",@"PS",@"PA",@"PG",@"PY",@"PE",@"PH",@"PN",@"PL",@"PT",@"PR",@"QA",@"RE",@"RO",@"RU",@"RW",@"SH",@"KN",@"LC",@"PM",@"VC",@"BL",@"MF",@"WS",@"SM",@"ST",@"SA",@"SN",@"RS",@"SC",@"SL",@"SG",@"SX",@"SK",@"SI",@"SB",@"SO",@"ZA",@"GS",@"SS",@"ES",@"LK",@"SD",@"SR",@"SJ",@"SZ",@"SE",@"CH",@"SY",@"TW",@"TJ",@"TZ",@"TH",@"TL",@"TG",@"TK",@"TO",@"TT",@"TN",@"TR",@"TM",@"TC",@"TV",@"UG",@"UA",@"AE",@"GB",@"US",@"UY",@"UZ",@"VU",@"VE",@"VN",@"VI",@"WF",@"EH",@"YE",@"ZM",@"ZW", nil];
   
    
    //---- Search ------------------------------------------------------------------//
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.placeholder = nil;
    //[self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    
    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    //self.searchResultsController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    
    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    //
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    //[self.tableView setContentOffset:CGPointMake(0, self.searchController.searchBar.frame.size.height)];

    /*if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        self.automaticallyAdjustsScrollViewInsets=YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.extendedLayoutIncludesOpaqueBars = YES;*/
    
    
    _mCountryTable.allowsMultipleSelectionDuringEditing = NO;
    
    _mCountryTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.definesPresentationContext = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /*UIView *buggyView = [self.searchDisplayController.searchBar.subviews firstObject];
    // buggyView bounds and center are incorrect after returning from controller, so adjust them.
    buggyView.bounds = self.searchDisplayController.searchBar.bounds;
    buggyView.center = CGPointMake(CGRectGetWidth(buggyView.bounds)/2, CGRectGetHeight(buggyView.bounds)/2);*/
}

- (IBAction)backToPreviousView:(id)sender {
    
    
    if([rateFinder isEqualToString:@"picker"]) {
        [self performSegueWithIdentifier:@"countrySelected" sender:self];
    }
    
    else if ([rateFinder isEqualToString:@"changeCountryPicker"]){
        [self performSegueWithIdentifier:@"backToSettings" sender:self];
    
    }
    

    
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    mSearchResults = [[countries filteredArrayUsingPredicate:resultPredicate] mutableCopy];
}



- (void)updateSearchResultsForSearchController:(UISearchController *)aSearchController {
    NSString *searchString = aSearchController.searchBar.text;
    NSLog(@"searchString=%@", searchString);
    [self filterContentForSearchText:searchString
                               scope:[[self.searchController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchController.searchBar
                                                     selectedScopeButtonIndex]]];
    [_mCountryTable reloadData];
    return ;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    mIsSearching = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self.searchController setActive:NO];
        [_mCountryTable reloadData];
        
    });
    //[self.searchController setActive:NO];
    
}
/*
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UISearchBar *searchBar = self.searchController.searchBar;
    CGRect searchBarFrame = searchBar.frame;
    if (isSearching) {
        searchBarFrame.origin.y = 0;
    } else {
        searchBarFrame.origin.y =( MAX(0, scrollView.contentOffset.y + scrollView.contentInset.top)) - 1;
    }
    self.searchController.searchBar.frame = searchBarFrame;
}
*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender{
    
    if ([segue.identifier isEqualToString:@"showRate"]) {
        
        /*
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        dvc = segue.destinationViewController;
        dvc.countryNameString = self.countryName;
        dvc.countryImageString =self.countrycode;
        dvc.rateD = dataD;*/

       
        
    }
    


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.searchController.active ) {
        
        
        NSString *sCountry = mSearchResults[indexPath.row];
        for(int i=0; i< [countries count]; i++) {
            
            if([sCountry isEqualToString:countries[i]]) {
                self.callingCode = countryCC[i];
                self.countryName = countries[i];
                self.countrycode = countryCode[i];
                break;
            }
        }
    }
    else {
        
        self.callingCode = countryCC[indexPath.row];
        self.countryName = countries[indexPath.row];
        self.countrycode = countryCode[indexPath.row];
    }
    if([rateFinder isEqualToString:@"picker"]) {
        
        //if ([self.se   segue.identifier isEqualToString:@"countrySelected"]) {
        // do something here
        [self performSegueWithIdentifier:@"countrySelected" sender:self];
    }
    
    else if ([rateFinder isEqualToString:@"changeCountryPicker"])
    {

        [self performSegueWithIdentifier:@"backToSettings" sender:self];
    }
    else {
        
    }

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (self.searchController.active )
        return  [mSearchResults count];
        else
    return [countries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
 
    if (self.searchController.active ) {
        
        NSString *sCountry = mSearchResults[indexPath.row];
        for(int i=0; i< [countries count]; i++) {
            
            if([sCountry isEqualToString:countries[i]]) {
                
                
                NSString *key = countryCode[i];
                NSString *imageName = [NSString stringWithFormat:key,@".png"];
                
                
                UILabel *countryName = (UILabel *)[cell viewWithTag:101];
                countryName.text = [NSString stringWithFormat:@"%@ (+%@)",sCountry,countryCC[i]];


                
                UIImageView *imgView = (UIImageView *)[cell viewWithTag:100];
                
                
                
                imgView.image = [countryTableViewController imageNamed:imageName];
                
                
                break;
  
            }
            
        }
        
    }
        
        
    else
        
    {
        
        
        NSString *key = countryCode[indexPath.row];
        NSString *imageName = [NSString stringWithFormat:key,@".png"];
        
        
        UILabel *countryName = (UILabel *)[cell viewWithTag:101];
        countryName.text = [NSString stringWithFormat:@"%@ (+%@)",countries[indexPath.row],countryCC[indexPath.row]];
        
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:100];
        imgView.image = [countryTableViewController imageNamed:imageName];
        
        
        
    }
    
    return cell;

}


+ (UIImage *)imageNamed:(NSString *)imageName
{
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:LOGIN_PROCESS_BUNDLE withExtension:@"bundle"];
    NSBundle *  ChatBundle = [[NSBundle alloc] initWithURL:bundleURL];
    return [UIImage imageNamed:imageName inBundle:ChatBundle compatibleWithTraitCollection:nil];
}

@end
