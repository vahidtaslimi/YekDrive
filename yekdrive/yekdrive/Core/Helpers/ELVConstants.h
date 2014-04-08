

static NSString *  const ELVLocalStorageDataPath = @"Data";
// Database application settings names
static NSString * const ELVDBAppSettingDatabaseVersion = @"DatabaseVersion";


// Default timeout in seconds for web requests.
static const int NTXWebIODefaultTimeout = 4 * 60 * 60; //4 hours
static const int NTXWebIODefaultDownloadAttachmentTimeout = 4 * 60 * 60; //4 hours
static const int NTXWebIODefaultPostTimeout = 4 * 60 * 60; //4 hours

static const int NTXTabIndexTasks = 0;
static const int NTXTabIndexForms = 1;
static const int NTXTabIndexDrafts = 2;
static const int NTXTabIndexOutbox = 3;

static const int NTXSQLITE_IOERR = 10;

// http://iphonedevwiki.net/index.php/AudioServices
static const int NTXSystemSoundIdSentEmail = 1001;

static const int NTXAutoRefreshTasksInMinutes = 15;

static NSString *  const NTXDeviceTypeiPhone = @"nintex-mobile-iphone";
static NSString *  const NTXDeviceTypeiPad = @"nintex-tablet-ipad";
static NSString * const NTXPrivacyStatementLink = @"http://www.nintex.com/en-US/Pages/Privacy.aspx";
static NSString * const NTXAboutTwitterLink = @"http://twitter.com/nintex";
static NSString * const NTXAboutFacebookAppLink = @"fb://profile/356380610362";
static NSString * const NTXAboutFacebookLink = @"http://www.facebook.com/nintex";
static NSString * const NTXAboutLinkedInLink = @"http://www.linkedin.com/company/nintex";
static NSString * const NTXAboutYouTubeLink = @"http://www.youtube.com/user/nintex";
static NSString * const NTXAboutNintexLink = @"http://www.nintex.com";

static const CGFloat NTXFontSize = 17;
static const CGFloat NTXDescriptionFontSize = 12;
static const CGFloat NTXTextFieldHeight = 45;
static const CGFloat NTXButtonHeight = 40;
static const int NTXABitOfPadding = 8;
static const int NTXDateTimeOffsetCount = 27;
static const int NTXPeoplePickerControlMaxServerSearchResultsCount = 10;

// Used as a delimiter to pass an array of strings around as a single delimited string
static NSString *  const NTXStringArrayDelimiter = @"\t";

static NSString *  const NTXDateTimeUTCFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSS'Z'";
static NSString *  const NTXDateTimeOffsetFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSSSSSZ";

static const CGFloat NTXMaxUploadPhotoAllowedSize = 1280;
static const CGFloat NTXThumnailPhotoWidth = 120;
static const CGFloat NTXIconImageWidth = 60;  // 2 * 30 to allow for retina display

static NSString *  const NTXServerErrorFriendlyExceptionMessage = @"ErrorMessage";
static NSString *  const NTXServerErrorFriendlyCorrelationId = @"CorrelationId";

static NSString *  const NTXLocalStorageDocumentsPath = @"Documents";
static NSString *  const NTXLocalStorageNintexMobileAppPath = @"Nintex Mobile.app";

static NSString *  const NTXLocalStorageFormsPath = @"forms";
static NSString *  const NTXLocalStorageTasksPath = @"tasks";
static NSString *  const NTXLocalStorageCurrentLoggedInProfile = @"CurrentLoggedInProfile";
static NSString *  const NTXLocalStorageLastLoggedInProfile = @"LastLoggedInProfile";
static NSString *  const NTXRepositoryServiceUrl = @"_vti_bin/NintexFormsServices/NfMobileAppService.svc/";
static NSString *  const NTXFormsVersionWebServiceUrl = @"_vti_bin/NintexWorkflow/NfRestService.svc/GetDevices";

static NSString *  const NTXTasksRepositoryServiceUrlGetTasks = @"Tasks";
static NSString *  const NTXFormsRepositoryServiceUrlGetForms = @"Forms";
static NSString *  const NTXSourcesRepositoryServiceUrlGetSources = @"Sources";
static NSString *  const NTXResourcesRepositoryServiceUrlGetResources = @"Resource";
static NSString *  const NTXPeoplePickerRepositoryServiceUrlGetPeople = @"SearchEntities";

static NSString *  const NTXAuthenticationServiceUrl = @"authenticate";

static NSString * const NTXFormDataJsonFileName = @"FormData.json";
static NSString * const NTXFormDataPackageFileName = @"form.zip";
static NSString * const NTXFormDataPackagingFolderName = @"packaging";

static NSString *  const NTXJsonKeyAttachmentFileName = @"Name";
static NSString *  const NTXJsonKeyAttachmentVideoDuration = @"Duration";

// Test Server
//static NSString *  const NTXNintexLiveWebServiceUrl = @"https://nintexmobiletest.nintex.com/";

// Live Server
static NSString *  const NTXNintexLiveWebServiceUrl = @"https://mobile.nintex.com/";

static NSString *  const NTXNintexLiveLogonUrl = @"Login.aspx";
static NSString *  const NTXNintexLiveLogonCompleteUrl = @"AcsResponse.aspx";
static NSString *  const NTXNintexLiveErrorCodeUseNotRegistered = @"UserNotRegistered";

static NSString *  const NTXControlTypeDateTime = @"DateTime";
static NSString *  const NTXControlTypeDateOnly = @"DateOnly";
static NSString *  const NTXControlTypeBoolean = @"Boolean";
static NSString *  const NTXControlTypeInteger = @"Integer";
static NSString *  const NTXControlTypeDecimal = @"Decimal";
static NSString *  const NTXControlTypeString = @"String";
static NSString *  const NTXControlTypeSingleChoice = @"SingleChoice";
static NSString *  const NTXControlTypeMultiChoice = @"MultiChoice";
static NSString *  const NTXControlTypeAttachments = @"Attachments";
static NSString *  const NTXControlTypePeople = @"People";
static NSString *  const NTXControlTypeRepeater = @"Repeater";

static NSString * const NTXControlValidationDataTypeString = @"String";
static NSString * const NTXControlValidationDataTypeInteger = @"Integer";
static NSString * const NTXControlValidationDataTypeDouble = @"Double";
static NSString * const NTXControlValidationDataTypeDate = @"Date";
static NSString * const NTXControlValidationDataTypeCurrency = @"Currency";

static NSString *  const NTXSupportEmail = @"nmapplog@nintex.com";
static NSString *  const NTXCrashLogFileName = @"Nintex.nml";



static NSString * const NTXHTTPHeaderETag = @"NM_ETag";
static NSString * const NTXHTTPHeaderLastModified = @"NM_LastModified";
static NSString * const NTXHTTPHeaderSourceId = @"NM_SourceId";
static NSString * const NTXHTTPHeaderRequestId = @"NM_RequestId";
static NSString * const NTXNintexLiveAuthenticationTokenHeader = @"NL_AuthenticationToken";
static NSString * const NTXHTTPHeaderNFVersion = @"NF_Version";

static NSString * const NTXFormControlPropertiesMultiLineTextBox = @"MultiLineTextBoxFormControlProperties";
static NSString * const NTXFormControlPropertiesAttachment = @"AttachmentFormControlProperties";
static NSString * const NTXFormControlPropertiesLabel = @"LabelFormControlProperties";
static NSString * const NTXFormControlPropertiesHtml = @"HtmlFormControlProperties";
static NSString * const NTXFormControlPropertiesTextBox = @"TextBoxFormControlProperties";
static NSString * const NTXFormControlPropertiesPeoplePicker = @"PeoplePickerFormControlProperties";
static NSString * const NTXFormControlPropertiesGeoLocation = @"GeoLocationFormControlProperties";  
static NSString * const NTXFormControlPropertiesDateTime = @"DateTimeFormControlProperties";
static NSString * const NTXFormControlPropertiesImage = @"ImageFormControlProperties";
static NSString * const NTXFormControlPropertiesChoice = @"ChoiceFormControlProperties";
static NSString * const NTXFormControlPropertiesBoolean = @"BooleanFormControlProperties";
static NSString * const NTXFormControlPropertiesButton = @"ButtonFormControlProperties";
static NSString * const NTXFormControlPropertiesRepeater = @"RepeaterFormControlProperties";

static NSString * const NTXFormTypeListForm = @"ListForm";
static NSString * const NTXFormTypePreviewForm = @"PreviewForm";

static const int NTXFormInfoIconHeight = 25;
static const int NTXFormNavBarIconHeight = 44;
static const int NTXScreenHeightPotrait = 1004;
static const int NTXScreenWidthPotrait = 768;
static const int NTXScreenHeightLandscape = 748;
static const int NTXScreenWidthLandscapeMaster = 320;
static const int NTXScreenDetailWidthLandscape = 700; //actual is 703 but we use 700
static const CGFloat NTXIphoneFormSidePadding = 20;
static const CGFloat NTXIpadPortraitFormSidePadding = 20;
static const CGFloat NTXIpadLandscapeFormSidePadding = 20;

static NSString * const NTXDefaultListFormIcon = @"DefaultFormIcon";
static NSString * const NTXDefaultListTaskIcon = @"DefaultTaskIcon";
static NSString * const NTXErrorListIcon = @"triangular_exclamation";

static int const NTXKeyboardAccessoryViewHeight = 40;

static NSString *const NTXPeoplePickerControlNonResolvedUserPrefix = @"NONRESOLVED:";
static NSString *const NTXPeoplePickerControlSharePointGroupPrefix = @"SharePointGroup:";
static NSString *const NTXPeoplePickerControlSelectionSetPrefix = @"SelectionSet:";
static NSString *const NTXPeoplePickerControlAttemptedResolve = @"AttemptToResolve";

static NSString *const NTXPeoplePickerControlValidationParam = @"PeoplePickerValidationFailure";
static NSString *const NTXControlValidationParam = @"ControlValidation";

static NSString *const NTXFormControlTypeUniqueIdLabel = @"c0a89c70-0781-4bd4-8623-f73675005e00";
static NSString *const NTXFormControlTypeUniqueIdChoice = @"c0a89c70-0781-4bd4-8623-f73675005e02";
static NSString *const NTXFormControlTypeUniqueIdDateTime = @"c0a89c70-0781-4bd4-8623-f73675005e03";
static NSString *const NTXFormControlTypeUniqueIdBoolean = @"c0a89c70-0781-4bd4-8623-f73675005e04";
static NSString *const NTXFormControlTypeUniqueIdSingleLineTextBox = @"c0a89c70-0781-4bd4-8623-f73675005e05";
static NSString *const NTXFormControlTypeUniqueIdMultilineTextBox = @"c0a89c70-0781-4bd4-8623-f73675005e06";
static NSString *const NTXFormControlTypeUniqueIdHtml = @"c0a89c70-0781-4bd4-8623-f73675005e07";
static NSString *const NTXFormControlTypeUniqueIdImage = @"c0a89c70-0781-4bd4-8623-f73675005e08";
static NSString *const NTXFormControlTypeUniqueIdButton = @"c0a89c70-0781-4bd4-8623-f73675005e09";
static NSString *const NTXFormControlTypeUniqueIdHyperlink = @"c0a89c70-0781-4bd4-8623-f73675005e10";
static NSString *const NTXFormControlTypeUniqueIdHyperlinkColumn = @"a0c89d70-0781-4bd4-8623-a73675005a05";
static NSString *const NTXFormControlTypeUniqueIdLine = @"c0a89c70-0781-4bd4-8623-f73675005e11";
static NSString *const NTXFormControlTypeUniqueIdPeoplePicker = @"c0a89c70-0781-4bd4-8623-f73675005e12";
static NSString *const NTXFormControlTypeUniqueIdFrame = @"c0a89c70-0781-4bd4-8623-f73675005e13";
static NSString *const NTXFormControlTypeUniqueIdPanel = @"c0a89c70-0781-4bd4-8623-f73675005e14";
static NSString *const NTXFormControlTypeUniqueIdRepeater = @"c0a89c70-0781-4bd4-8623-f73675005e16";
static NSString *const NTXFormControlTypeUniqueIdGeoPicker = @"c0a89c70-0781-4bd4-8623-f73675005e19";
static NSString *const NTXFormControlTypeUniqueIdAttachment = @"5f8b447a-4195-485b-9a04-477d7f24be73";
static NSString *const NTXFormControlTypeUniqueIdListItem = @"2c285c16-d4e6-49eb-8a6a-d9aa41e9e71b";
static NSString *const NTXFormControlTypeUniqueIdCalculationControl = @"c0a89c70-0781-4bd4-8623-f73675005e17";


static NSString *const NTXDefaultApiVersion = @"2.1.0.0";
static NSString *const NTXApiVersion2200 = @"2.2.0.0";
static NSString *const NTXApiVersion2210 = @"2.2.1.0";
static NSString *const NTXApiVersion2300 = @"2.3.0.0";
