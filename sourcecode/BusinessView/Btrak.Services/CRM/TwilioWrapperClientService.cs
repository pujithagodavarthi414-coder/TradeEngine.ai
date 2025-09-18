using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.Crm;
using Btrak.Models.Crm.Call;
using BTrak.Common;
using Twilio.Jwt.AccessToken;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Rest.Api.V2010.Account.Call;
using System.Web;
using Newtonsoft.Json;
using System.IO;
using System.Net;
using Twilio.Jwt;
using Twilio.Jwt.Client;
using Twilio.Rest.Video.V1;
using Twilio.Rest.Video.V1.Room;
using ParticipantStatus = Twilio.Rest.Video.V1.Room.ParticipantResource.StatusEnum;
using Twilio.Base;
using RecordingResource = Twilio.Rest.Video.V1.RecordingResource;
using Btrak.Models.File;
using Btrak.Models.CompanyStructure;
using Btrak.Services.CompanyStructure;
using Btrak.Services.FileUploadDownload;
using CompositionResource = Twilio.Rest.Video.V1.CompositionResource;
using Twilio.Converters;
using System.Configuration;

namespace Btrak.Services.CRM
{
    public class TwilioWrapperClientService : ITwilioWrapperClientService
    {
        private readonly ExternalServiceProviderRepository _externalServiceProviderRepository;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly IFileStoreService _fileStoreService;
        private readonly CallRepository _callRepository;

        public TwilioWrapperClientService(ExternalServiceProviderRepository externalServiceProviderRepository, CallRepository callRepository, ICompanyStructureService companyStructureService, IFileStoreService fileStoreService)
        {
            _externalServiceProviderRepository = externalServiceProviderRepository;
            _callRepository = callRepository;
            _companyStructureService = companyStructureService;
            _fileStoreService = fileStoreService;
        }

        public List<OutgoingCallerIdModel> GetCallingNumbers(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);
            if (callVariables != null)
            {

                string accountSid = callVariables.AccountSid;
                string authToken = callVariables.AuthToken;

                TwilioClient.Init(accountSid, authToken);

                var outgoingCallerIds = IncomingPhoneNumberResource.Read(limit: 20);
                List<OutgoingCallerIdModel> callerIds = new List<OutgoingCallerIdModel>();
                foreach (var record in outgoingCallerIds)
                {
                    OutgoingCallerIdModel callerId = new OutgoingCallerIdModel()
                    {
                        AccountSid = record.AccountSid,
                        DateCreated = record.DateCreated,
                        DateUpdated = record.DateUpdated,
                        FriendlyName = record.FriendlyName,
                        PhoneNumber = record.PhoneNumber.ToString(),
                        Sid = record.Sid,
                        Uri = record.Uri
                    };
                    callerIds.Add(callerId);
                }
                return callerIds;
            }
            return null;
        }

        public CallResourceModel CreateCall(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);
            if (callVariables != null)
            {
                string accountSid = callVariables.AccountSid;
                string authToken = callVariables.AuthToken;

                TwilioClient.Init(accountSid, authToken);

                var statusCallbackEvent = new List<string> {
                    "initiated",
                    "answered"
                };

                CallResource callResource = CallResource.Create(
                    method: Twilio.Http.HttpMethod.Get,
                    statusCallback: new Uri("http://610213a80327.ngrok.io/Call/CallApi/GetCallStatusCallback"),
                    statusCallbackEvent: statusCallbackEvent,
                    statusCallbackMethod: Twilio.Http.HttpMethod.Post,
                    url: new Uri("http://demo.twilio.com/docs/voice.xml"),
                    to: new Twilio.Types.PhoneNumber("+919000972459"),
                    from: new Twilio.Types.PhoneNumber("+12516551639")
                );

                CallResourceModel callResourceModel = new CallResourceModel()
                {
                    AccountSid = callResource.AccountSid,
                    Annotation = callResource.Annotation,
                    AnsweredBy = callResource.AnsweredBy,
                    ApiVersion = callResource.ApiVersion,
                    CallerName = callResource.CallerName,
                    DateCreated = callResource.DateCreated,
                    DateUpdated = callResource.DateUpdated,
                    Direction = callResource.Direction,
                    Duration = callResource.Duration,
                    EndTime = callResource.EndTime,
                    ForwardedFrom = callResource.ForwardedFrom,
                    From = callResource.From,
                    FromFormatted = callResource.FromFormatted,
                    GroupSid = callResource.GroupSid,
                    ParentCallSid = callResource.ParentCallSid,
                    PhoneNumberSid = callResource.PhoneNumberSid,
                    Price = callResource.Price,
                    PriceUnit = callResource.PriceUnit,
                    QueueTime = callResource.QueueTime,
                    Sid = callResource.Sid,
                    StartTime = callResource.StartTime,
                    Status = callResource.Status.ToString(),
                    SubresourceUris = callResource.SubresourceUris,
                    To = callResource.To,
                    ToFormatted = callResource.ToFormatted,
                    TrunkSid = callResource.TrunkSid,
                    Uri = callResource.Uri
                };

                return callResourceModel;

            }
            return null;
        }

        public string GetToken(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);
            if (callVariables != null)
            {
                // These are specific to Voice
                const string identity = "user";

                // Create a Voice grant for this token
                var grant = new VoiceGrant();
                grant.OutgoingApplicationSid = callVariables.AppSid;

                // Optional: add to allow incoming calls
                grant.IncomingAllow = false;

                var grants = new HashSet<IGrant>
                {
                    { grant }
                };

                //var scopes = new HashSet<IScope>
                //{
                //    new OutgoingClientScope(callVariables.AppSid)
                //};
                //var capability = new ClientCapability(callVariables.AccountSid,
                //                                      callVariables.AuthToken,
                //                                      scopes: scopes);

                //return capability.ToJwt();

                // Create an Access Token generator
                var token = new Token(
                    callVariables.AccountSid,
                    callVariables.ApiKey,
                    callVariables.ApiSecret,
                    identity,
                    grants: grants);

                return token.ToJwt();
            }
            return "";
        }

        public CallVariables GetCallVariables(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CallVariables callVariable;
            List<ExpernalServiceProviderOutputModel> expernalServiceProviderOutputModels = _externalServiceProviderRepository.GetExternalServiceProperties("VOICE", loggedInContext.LoggedInUserId, validationMessages);
            // Put your Twilio API credentials here
            if (expernalServiceProviderOutputModels != null)
            {
                callVariable = new CallVariables();
                callVariable.AccountSid = expernalServiceProviderOutputModels.FirstOrDefault(x => x.PropertyName == "AccountSID").PropertyValue;
                callVariable.AuthToken = expernalServiceProviderOutputModels.FirstOrDefault(x => x.PropertyName == "AuthToken").PropertyValue;
                callVariable.AppSid = expernalServiceProviderOutputModels.FirstOrDefault(x => x.PropertyName == "AppSID").PropertyValue;
                callVariable.ApiKey = expernalServiceProviderOutputModels.FirstOrDefault(x => x.PropertyName == "APIKey").PropertyValue;
                callVariable.ApiSecret = expernalServiceProviderOutputModels.FirstOrDefault(x => x.PropertyName == "APISecret").PropertyValue;
                return callVariable;
            }
            else
            {
                return null;
            }

        }

        public CallResourceModel GetCallStatusCallback(MakeCallInputModel makeCallInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);
            if (callVariables != null)
            {
                string accountSid = callVariables.AccountSid;
                string authToken = callVariables.AuthToken;

                TwilioClient.Init(accountSid, authToken);

                var callResource = CallResource.Fetch(pathSid: makeCallInputModel.CallPathSID);

                CallResourceModel callResourceModel = MapCallResource(callResource, null, makeCallInputModel);

                return callResourceModel;
            }
            return null;
        }

        public CallResourceModel MakeCall(MakeCallInputModel makeCallInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);
            if (callVariables != null)
            {
                string accountSid = callVariables.AccountSid;
                string authToken = callVariables.AuthToken;

                TwilioClient.Init(accountSid, authToken);

                var statusCallbackEvent = new List<string> {
                    "initiated",
                    "answered"
                };

                CallResource callResource = CallResource.Create(
                    to: new Twilio.Types.PhoneNumber(makeCallInputModel.CallTo),
                    from: new Twilio.Types.PhoneNumber(makeCallInputModel.CallFrom),
                    record: true,
                    url: new Uri("http://demo.twilio.com/docs/voice.xml")
                );

                CallResourceModel callResourceModel = MapCallResource(callResource, null, makeCallInputModel);

                return callResourceModel;

            }
            return null;
        }

        public CallResourceModel EndCall(MakeCallInputModel makeCallInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);
            if (callVariables != null)
            {
                string accountSid = callVariables.AccountSid;
                string authToken = callVariables.AuthToken;

                TwilioClient.Init(accountSid, authToken);

                var callResource = CallResource.Update(
                    status: CallResource.UpdateStatusEnum.Completed,
                    pathSid: makeCallInputModel.CallPathSID
                );

                var recordings = Twilio.Rest.Api.V2010.Account.RecordingResource.Read(
                    callSid: makeCallInputModel.CallPathSID, limit: 1,
                    pathAccountSid: accountSid
                );
                Dictionary<string, string> recordingURLs = new Dictionary<string, string>();

                foreach (Twilio.Rest.Api.V2010.Account.RecordingResource record in recordings)
                {
                    recordingURLs.Add(record.Sid, "https://api.twilio.com" + record.Uri.Replace(".json", ".mp3"));
                }

                CallResourceModel callResourceModel = MapCallResource(callResource, recordingURLs, makeCallInputModel);

                return callResourceModel;
            }
            return null;
        }

        public CallResourceModel MapCallResource(CallResource callResource, Dictionary<string, string> recordingURLs, MakeCallInputModel makeCallInputModel)
        {
            CallResourceModel callResourceModel = new CallResourceModel()
            {
                AccountSid = callResource.AccountSid,
                Annotation = callResource.Annotation,
                AnsweredBy = callResource.AnsweredBy,
                ApiVersion = callResource.ApiVersion,
                CallerName = callResource.CallerName,
                DateCreated = callResource.DateCreated,
                DateUpdated = callResource.DateUpdated,
                Direction = callResource.Direction,
                Duration = callResource.Duration,
                EndTime = callResource.EndTime,
                ForwardedFrom = callResource.ForwardedFrom,
                From = string.IsNullOrEmpty(makeCallInputModel.CallFrom) ? callResource.From : makeCallInputModel.CallFrom,
                FromFormatted = callResource.FromFormatted,
                GroupSid = callResource.GroupSid,
                ParentCallSid = callResource.ParentCallSid,
                PhoneNumberSid = callResource.PhoneNumberSid,
                Price = callResource.Price,
                PriceUnit = callResource.PriceUnit,
                QueueTime = callResource.QueueTime,
                Sid = callResource.Sid,
                StartTime = callResource.StartTime,
                Status = callResource.Status.ToString(),
                SubresourceUris = callResource.SubresourceUris,
                To = string.IsNullOrEmpty(makeCallInputModel.CallTo) ? callResource.To : makeCallInputModel.CallTo,
                ToFormatted = callResource.ToFormatted,
                TrunkSid = callResource.TrunkSid,
                Uri = callResource.Uri
            };
            if (recordingURLs != null)
            {
                callResourceModel.RecordingURLs = recordingURLs;
            }
            return callResourceModel;
        }

        public Stream GetStreamFromRecordUrl(string recordSid, string recordUrl)
        {
            try
            {
                WebClient client = new WebClient();
                byte[] data = client.DownloadData(new Uri(recordUrl));
                return new MemoryStream(data);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(ex);
                return null;
            }
        }

        public bool DeleteRecordingTwilio(string recordSid, string recordUrl)
        {
            try
            {
                var recordingResource = Twilio.Rest.Api.V2010.Account.RecordingResource.Delete(char.ToUpper(recordSid[0]) + recordSid.Substring(1));
                return recordingResource;
            }
            catch (Exception ex)
            {
                LoggingManager.Error(ex);
                return false;
            }
        }

        public List<RoomDetailsModel> GetAllRooms(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);
            if (callVariables != null)
            {

                string accountSid = callVariables.AccountSid;
                string authToken = callVariables.AuthToken;

                TwilioClient.Init(accountSid, authToken);

                var rooms = RoomResource.Read();
                List<RoomDetailsModel> roomDetails = new List<RoomDetailsModel>();
                foreach (var record in rooms)
                {
                    RoomDetailsModel room = new RoomDetailsModel()
                    {
                        Name = record.UniqueName,
                        MaxParticipants = (int)record.MaxParticipants,
                        RoomSid = record.Sid,
                        Status = record.Status.ToString()
                    };
                    roomDetails.Add(room);
                }
                return roomDetails;
            }
            return null;
        }

        public object CreateRoom(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);
            if (callVariables != null)
            {
                bool canCreate = _callRepository.UpsertRoomVideoValidation(roomDetails, loggedInContext, validationMessages);
                if (canCreate)
                {
                    TwilioClient.Init(callVariables.AccountSid, callVariables.AuthToken);

                    RoomResource room = RoomResource.Create(
                        type: RoomResource.RoomTypeEnum.Group,
                        uniqueName: roomDetails.Name,
                        recordParticipantsOnConnect: true
                    );
                    if (room.UniqueName != null)
                    {
                        roomDetails.RoomSid = room.Sid;
                        roomDetails.Status = room.Status.ToString();
                        _callRepository.UpsertRoomVideo(roomDetails, loggedInContext, validationMessages);
                    }
                    return room;
                }
            }
            return null;
        }

        public object UpdateRoomStatus(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);
            if (callVariables != null)
            {
                TwilioClient.Init(callVariables.AccountSid, callVariables.AuthToken);

                if (roomDetails.Status == "completed")
                {
                    var roomStatus = RoomResource.Read(uniqueName: roomDetails.Name, status: RoomResource.RoomStatusEnum.InProgress);

                    foreach (var record in roomStatus)
                    {
                        roomDetails.RoomSid = record.Sid;
                    }

                    var participantList = RoomParticipants(roomDetails, loggedInContext, validationMessages);
                    if (participantList != null && participantList.Count() > 0)
                    {
                        foreach(var p in participantList)
                        {
                            ParticipantResource participant = ParticipantResource.Update(
                                //roomDetails.RoomSid,
                                p.RoomSid,
                                p.Sid,
                                ParticipantStatus.Disconnected);
                            if (p.RoomSid != roomDetails.RoomSid)
                            {
                                roomDetails.RoomSid = p.RoomSid;
                            }
                        }
                    }
                    
                    var room = RoomResource.Update(
                        status: RoomResource.RoomStatusEnum.Completed,
                        pathSid: roomDetails.RoomSid
                    );

                    var groupingSid = new List<string> {roomDetails.RoomSid};

                    var recordings = RecordingResource.Read(groupingSid: groupingSid, limit: 20);

                    var canCompistion = false;
                    foreach (var record in recordings)
                    {
                        canCompistion = true;
                    }
                    if (canCompistion)
                    {
                        var layout = new
                        {
                            grid = new
                            {
                                video_sources = new string[] { "*" }
                            }
                        };

                        var address = ConfigurationManager.AppSettings["SiteUrl"];
                        //var url = "http://1346278033eb.ngrok.io/Call/CallApi/GetVideoCompositionStatusCallback";
                        var url = address + "/backend/Call/CallApi/GetVideoCompositionStatusCallback";

                        var composition = CompositionResource.Create(
                          roomSid: roomDetails.RoomSid,
                          audioSources: new List<string> { "*" },
                          videoLayout: layout,
                          format: CompositionResource.FormatEnum.Mp4,
                          statusCallback: new Uri(url),
                          statusCallbackMethod: Twilio.Http.HttpMethod.Post
                        );

                        VideoCallLogInputModel videoCallLogInputModel = new VideoCallLogInputModel();
                        videoCallLogInputModel.VideoRecordingLink = null;//result.FilePath;
                        videoCallLogInputModel.Extension = "mp4";
                        videoCallLogInputModel.Type = "video/mp4";
                        videoCallLogInputModel.FileName = null;//result.FileName;
                        videoCallLogInputModel.ReceiverId = roomDetails.ReceiverId;
                        videoCallLogInputModel.RoomName = roomDetails.Name;
                        videoCallLogInputModel.CompositionSid = composition.Sid;
                        videoCallLogInputModel.RoomSid = composition.RoomSid;
                        _callRepository.UpsertVideoCallLog(videoCallLogInputModel, loggedInContext, validationMessages);
                    }
                    return _callRepository.UpsertRoomVideo(roomDetails, loggedInContext, validationMessages);
                }
                else if (roomDetails.Status == "in-progress")
                {
                    var room = RoomResource.Update(
                        status: RoomResource.RoomStatusEnum.InProgress,
                        pathSid: roomDetails.RoomSid
                    );
                    return _callRepository.UpsertRoomVideo(roomDetails, loggedInContext, validationMessages);
                }
            }
            return null;
        }

        public List<ParticipantModel> RoomParticipants(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);
            if(callVariables != null)
            {
                ResourceSet<ParticipantResource> participants = ParticipantResource.Read( roomDetails.Name, ParticipantStatus.Connected);

                List<ParticipantModel> participantList = new List<ParticipantModel>();

                foreach (ParticipantResource p in participants)
                {
                    ParticipantModel participant = new ParticipantModel()
                    {
                        StartTime = p.StartTime,
                        DateUpdated = p.DateUpdated,
                        DateCreated = p.DateCreated,
                        Identity = p.Identity,
                        AccountSid = p.AccountSid,
                        RoomSid = p.RoomSid,
                        Sid = p.Sid,
                        EndTime = p.EndTime,
                        Duration = p.Duration
                    };
                    participantList.Add(participant);
                }
                return participantList;
            }
            return null;
        }

        public string GetVideoToken(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);
            if (callVariables != null)
            {
                string identity = "user";
                // These are specific to Voice
                if (roomDetails.ParticipantName != null && roomDetails.ParticipantName != "")
                {
                    identity = roomDetails.ParticipantName;
                }

                // Create a Voice grant for this token
                var grant = new VideoGrant();

                if (roomDetails.Name != null && roomDetails.Name != "")
                {
                    grant.Room = roomDetails.Name;
                }
                var grants = new HashSet<IGrant>
                {
                    { grant }
                };

                // Create an Access Token generator
                var token = new Token(
                    callVariables.AccountSid,
                    callVariables.ApiKey,
                    callVariables.ApiSecret,
                    identity,
                    grants: grants);

                return token.ToJwt();
            }
            return "";
        }

        public CallVariables GetVideoCallVariables(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CallVariables callVariable;
            List<ExpernalServiceProviderOutputModel> expernalServiceProviderOutputModels = _externalServiceProviderRepository.GetExternalServiceProperties("VIDEO", loggedInContext.LoggedInUserId, validationMessages);
            // Put your Twilio API credentials here
            if (expernalServiceProviderOutputModels != null)
            {
                callVariable = new CallVariables();
                callVariable.AccountSid = expernalServiceProviderOutputModels.FirstOrDefault(x => x.PropertyName == "AccountSID").PropertyValue;
                callVariable.AuthToken = expernalServiceProviderOutputModels.FirstOrDefault(x => x.PropertyName == "AuthToken").PropertyValue;
                callVariable.AppSid = expernalServiceProviderOutputModels.FirstOrDefault(x => x.PropertyName == "AppSID").PropertyValue;
                callVariable.ApiKey = expernalServiceProviderOutputModels.FirstOrDefault(x => x.PropertyName == "APIKey").PropertyValue;
                callVariable.ApiSecret = expernalServiceProviderOutputModels.FirstOrDefault(x => x.PropertyName == "APISecret").PropertyValue;
                return callVariable;
            }
            else
            {
                return null;
            }

        }

        public string GetVideoCallTokenForParticipant(RoomDetailsModel roomDetails, List<ValidationMessage> validationMessages)
        {
            var room = _callRepository.GetVideoRoomDetails(roomDetails, validationMessages);
            if (room != null)
            {
                LoggedInContext loggedInContext = new LoggedInContext()
                {
                    CompanyGuid = new Guid(room.CompanyId.ToString()),
                    LoggedInUserId = new Guid(room.CreatedByUserId.ToString())
                };
                if (room.Status == "in-progress")
                {
                    CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);
                    if (callVariables != null)
                    {
                        TwilioClient.Init(callVariables.AccountSid, callVariables.AuthToken);
                    }
                    var roomStatus = RoomResource.Read(uniqueName: roomDetails.Name, status: RoomResource.RoomStatusEnum.InProgress);
                    bool roomInprogress = false;
                    foreach (var record in roomStatus)
                    {
                        roomInprogress = true;
                    }

                    if (!roomInprogress)
                    {
                        UpsertRoomVideoRecording(room, loggedInContext, validationMessages);
                        RoomResource roomResource = RoomResource.Create(
                            type: RoomResource.RoomTypeEnum.Group,
                            uniqueName: roomDetails.Name,
                            recordParticipantsOnConnect: true
                        );
                        room.RoomSid = roomResource.Sid;
                        roomDetails.RoomSid = roomResource.Sid;
                        roomDetails.Status = roomResource.Status.ToString();
                        roomDetails.ReceiverId = room.ReceiverId;
                        roomDetails.Id = null;
                        _callRepository.UpsertRoomVideo(roomDetails, loggedInContext, validationMessages);
                    }
                    return GetVideoToken(roomDetails, loggedInContext, validationMessages);
                }
                else if (room.Status == "completed")
                {
                    return "completed";
                }
                else
                {
                    return null;
                }
            }
            else
            {
                return null;
            }
        }

        public object GetVideoCallToken(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            RoomDetailsModel room = _callRepository.GetVideoRoomDetails(roomDetails, validationMessages);
            if (room != null)
            {
                if (room.Status == "in-progress")
                {
                    CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);
                    if (callVariables != null)
                    {
                        TwilioClient.Init(callVariables.AccountSid, callVariables.AuthToken);
                    }
                    var roomStatus = RoomResource.Read(uniqueName: roomDetails.Name, status: RoomResource.RoomStatusEnum.InProgress);
                    bool roomInprogress = false;
                    foreach (var record in roomStatus)
                    {
                        roomInprogress = true;
                    }

                    if (!roomInprogress)
                    {
                        UpsertRoomVideoRecording(room, loggedInContext, validationMessages);
                        RoomResource roomResource = RoomResource.Create(
                            type: RoomResource.RoomTypeEnum.Group,
                            uniqueName: roomDetails.Name,
                            recordParticipantsOnConnect: true
                        );
                        room.RoomSid = roomResource.Sid;
                        roomDetails.RoomSid = roomResource.Sid;
                        roomDetails.Status = roomResource.Status.ToString();
                        roomDetails.ReceiverId = room.ReceiverId;
                        roomDetails.Id = null;
                        _callRepository.UpsertRoomVideo(roomDetails, loggedInContext, validationMessages);
                    }

                    var token = GetVideoToken(roomDetails, loggedInContext, validationMessages);
                    room.Token = token;
                    return room;
                }
                else if (room.Status == "completed")
                {
                    return "completed";
                }
                else
                {
                    return null;
                }
            }
            else
            {
                return null;
            }
        }

        public object GetVideoCallRecroding(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);
            if (callVariables != null)
            {
                TwilioClient.Init(callVariables.AccountSid, callVariables.AuthToken);
                var room = RoomResource.Fetch(pathSid: roomDetails.Name);
            }
            return null;
        }

        public string GetVideoCallRoomStatus(RoomDetailsModel roomDetails, List<ValidationMessage> validationMessages)
        {
            var room = _callRepository.GetVideoRoomDetails(roomDetails, validationMessages);
            if (room != null)
            {
                LoggedInContext loggedInContext = new LoggedInContext()
                {
                    CompanyGuid = new Guid(room.CompanyId.ToString()),
                    LoggedInUserId = new Guid(room.CreatedByUserId.ToString())
                };
                CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);
                if (callVariables != null)
                {
                    TwilioClient.Init(callVariables.AccountSid, callVariables.AuthToken);
                }
                var roomStatus = RoomResource.Read(uniqueName: roomDetails.Name, status: RoomResource.RoomStatusEnum.InProgress);
                bool roomInprogress = false;
                foreach (var record in roomStatus)
                {
                    roomInprogress = true;
                }
                if (!roomInprogress)
                {
                    return "completed";
                }
                else
                {
                    return "in-progress";
                }
            }
            else
            {
                return null;
            }
        }

        public void UpsertRoomVideoRecording(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var groupingSid = new List<string> { roomDetails.RoomSid };

            var recordings = RecordingResource.Read(groupingSid: groupingSid, limit: 20);

            var canCompistion = false;
            foreach (var record in recordings)
            {
                canCompistion = true;
            }
            if (canCompistion)
            {
                var layout = new
                {
                    grid = new
                    {
                        video_sources = new string[] { "*" }
                    }
                };

                var address = ConfigurationManager.AppSettings["SiteUrl"];
                //var url = "http://1346278033eb.ngrok.io/Call/CallApi/GetVideoCompositionStatusCallback";
                var url = address + "/backend/Call/CallApi/GetVideoCompositionStatusCallback";

                var composition = CompositionResource.Create(
                  roomSid: roomDetails.RoomSid,
                  audioSources: new List<string> { "*" },
                  videoLayout: layout,
                  format: CompositionResource.FormatEnum.Mp4,
                  statusCallback: new Uri(url),
                  statusCallbackMethod: Twilio.Http.HttpMethod.Post
                );

                VideoCallLogInputModel videoCallLogInputModel = new VideoCallLogInputModel();
                videoCallLogInputModel.VideoRecordingLink = null;//result.FilePath;
                videoCallLogInputModel.Extension = "mp4";
                videoCallLogInputModel.Type = "video/mp4";
                videoCallLogInputModel.FileName = null;//result.FileName;
                videoCallLogInputModel.ReceiverId = roomDetails.ReceiverId;
                videoCallLogInputModel.RoomName = roomDetails.Name;
                videoCallLogInputModel.CompositionSid = composition.Sid;
                videoCallLogInputModel.RoomSid = composition.RoomSid;
                _callRepository.UpsertVideoCallLog(videoCallLogInputModel, loggedInContext, validationMessages);
            }
            roomDetails.Status = "completed";
            _callRepository.UpsertRoomVideo(roomDetails, loggedInContext, validationMessages);
        }

        public string GetVideoCompositionStatusCallback(CompositionCallbackModel composition, List<ValidationMessage> validationMessages)
        {
            if (composition.StatusCallbackEvent == "composition-available" || composition.StatusCallbackEvent == "available")
            {
                var compositionDetails = _callRepository.GetVideoCallLogByComposition(composition.CompositionSid, validationMessages);
                LoggedInContext loggedInContext = new LoggedInContext()
                {
                    LoggedInUserId = new Guid(compositionDetails.UserId.ToString()),
                    CompanyGuid = compositionDetails.CompanyId
                };

                CallVariables callVariables = GetCallVariables(loggedInContext, validationMessages);

                var compositions = CompositionResource.Read(
                           roomSid: composition.RoomSid,
                           status: CompositionResource.StatusEnum.Completed
                        );

                CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);
                try
                {
                    foreach (var record in compositions)
                    {
                        string recordSid = record.Sid;
                        string uri = "https://video.twilio.com/v1/Compositions/" + recordSid + "/Media?Ttl=3600";
                        var request = (HttpWebRequest)WebRequest.Create(uri);
                        request.Headers.Add("Authorization", "Basic " + Convert.ToBase64String(Encoding.ASCII.GetBytes(callVariables.ApiKey + ":" + callVariables.ApiSecret)));
                        request.AllowAutoRedirect = false;
                        string responseBody = new StreamReader(request.GetResponse().GetResponseStream()).ReadToEnd();
                        string x = responseBody;
                        var mediaLocation = JsonConvert.DeserializeObject<Dictionary<string, string>>(responseBody)["redirect_to"];
                        var med = mediaLocation;
                        Console.WriteLine(mediaLocation);
                        VideoCallLogInputModel videoCallLogInputModel = new VideoCallLogInputModel();

                        var result = new FileResult();
                        WebClient client = new WebClient();
                        byte[] data = client.DownloadData(new Uri(mediaLocation));
                        Stream fileStream = new MemoryStream(data);

                        BtrakPostedFile filePostInputModel = new BtrakPostedFile();
                        filePostInputModel.FileName = compositionDetails.RoomName + "" + recordSid + ".mp4";
                        filePostInputModel.ContentType = "video/mp4";
                        filePostInputModel.InputStream = fileStream;

                        result.FileName = compositionDetails.RoomName + "" + recordSid;
                        result.FilePath = _fileStoreService.UploadFiles(filePostInputModel, companyModel, 0, loggedInContext.LoggedInUserId);
                        result.FileExtension = "mp4";
                        result.FileSize = fileStream.Length;
                        //RecordingResource.Delete(pathSid: recordSid);
                        videoCallLogInputModel.VideoRecordingLink = result.FilePath;
                        videoCallLogInputModel.Extension = "mp4";
                        videoCallLogInputModel.Type = "video/mp4";
                        videoCallLogInputModel.FileName = result.FileName;
                        videoCallLogInputModel.ReceiverId = compositionDetails.ReceiverId;
                        videoCallLogInputModel.CompositionSid = recordSid;
                        videoCallLogInputModel.RoomSid = record.RoomSid;
                        videoCallLogInputModel.RoomName = compositionDetails.RoomName;
                        _callRepository.UpsertVideoCallLog(videoCallLogInputModel, loggedInContext, validationMessages);
                        CompositionResource.Delete(pathSid: recordSid);
                    }
                }
                catch (Exception ex)
                {
                    LoggingManager.Error(ex);
                }

                try
                {
                    var groupingSid = new List<string> { composition.RoomSid };

                    var recordings = RecordingResource.Read(groupingSid: groupingSid, limit: 100);

                    foreach (var record in recordings)
                    {
                        RecordingResource.Delete(pathSid: record.Sid);
                    }
                }
                catch (Exception ex)
                {
                    LoggingManager.Error(ex);
                }
            }
            return null;
        }
    }
}
