using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using Twilio.TwiML;
using Twilio.TwiML.Voice;
using static Twilio.TwiML.Voice.Dial;

namespace BTrak.Api.Controllers.Call
{

    public class TwilioCallController: ApiController
    {
        [HttpGet, HttpPost]
        [Route(RouteConstants.Connect)]
        public IHttpActionResult Connect(string From, string To, bool IsRecord)
        {
            var response = new VoiceResponse();
            var say = new Say("Please wait while we dial you into the call.");
            var dial = new Dial(callerId: From
                    , method: Twilio.Http.HttpMethod.Post
                    , timeout: 60, record: RecordEnum.RecordFromRinging);

            // If recording required
            if (IsRecord)
            {
                dial.Record = RecordEnum.RecordFromRinging;
                var recordingUrl = new Uri("http://localhost/api/record"); // Here I am giving the sample url, but it should be a public url to allow Twilio to post data

                dial.Number(phoneNumber: To
                    //, url: recordingUrl
                    , method: Twilio.Http.HttpMethod.Post);
            }
            else
                dial.Number(phoneNumber: To);

            response.Append(dial);


            return Ok(response.ToString());
        //return Content(response.ToString(), "application/xml");
        }
    }
}