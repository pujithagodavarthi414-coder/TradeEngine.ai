using Microsoft.Azure;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.Script.Serialization;

namespace BTrak.Common
{
    public class TimeZoneHelper
    {
        public static UserTimeZoneDetails GetUserCurrentTimeByIp(string ipAddress)
        {
            LoggingManager.Debug("started fetching user current time with " + ipAddress);

            var userTime = GetUserTimeZoneByIp(ipAddress);
            if (userTime != null)
            {
                var timeZoneInfoList = TimeZoneInfo.GetSystemTimeZones();
                var date = DateTimeOffset.ParseExact(TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, timeZoneInfoList.FirstOrDefault(p => p.DisplayName.Contains(userTime.GMTOffset))).ToString("yyyy-MM-dd'T'HH:mm:ss") + userTime.GMTOffset,
                                                    "yyyy-MM-dd'T'HH:mm:sszzz",
                                                    CultureInfo.InvariantCulture);
                return new UserTimeZoneDetails()
                {
                    CountryCode = userTime.CountryCode,
                    CountryName = userTime.CountryName,
                    GMTOffset = userTime.GMTOffset,
                    TimeZone = userTime.TimeZone,
                    UserTimeOffset = date
                };
            }
            return null;
        }

        public static UserTimeZoneDetails GetIstTime()
        {
            var timeZoneInfoList = TimeZoneInfo.GetSystemTimeZones();
            var date = DateTimeOffset.ParseExact(TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, timeZoneInfoList.FirstOrDefault(p => p.DisplayName.Contains("+05:30"))).ToString("yyyy-MM-dd'T'HH:mm:ss") + "+05:30",
                                                "yyyy-MM-dd'T'HH:mm:sszzz",
                                                CultureInfo.InvariantCulture);

            return new UserTimeZoneDetails()
            {
                CountryCode = "IN",
                CountryName = "India",
                TimeZone = "Asia/Kolkata",
                GMTOffset = "+05:30",
                UserTimeOffset = date,
                OffsetMinutes = 330
            };
        }

        public static int GetOffsetIntByIp(string ipAddress)
        {
            return GetUserTimeZoneByIp(ipAddress)?.OffsetMinutes ?? 0;
        }

        public static TimeZoneDetailsModel GetUserTimeZoneByIp(string ipAddress)
        {
            try
            {

                LoggingManager.Debug("calling ip api with ip address = " + ipAddress);

                using (var webClient = new System.Net.WebClient())
                {
                    var response = string.Empty;
                    var timeZoneApi = CloudConfigurationManager.GetSetting("TimeZoneApi");
                    var timeZoneApiFree = CloudConfigurationManager.GetSetting("TimeZoneApiFree");
                    try
                    {
                        response = webClient.DownloadString(string.Format(timeZoneApi, ipAddress));
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error("Fetching Time zone related details with ipaddress = " + ipAddress + " from paid is failed with the exception " + exception.Message.ToString());
                        response = webClient.DownloadString(timeZoneApiFree + ipAddress);
                    }

                    JavaScriptSerializer jss = new JavaScriptSerializer();
                    var responseData = jss.Deserialize<dynamic>(response);

                    string timeZoneName = responseData["timezone"];

                    if (!string.IsNullOrEmpty(timeZoneName))
                    {
                        return GetGmtOffsetByTimeZone(timeZoneName);
                    }

                    LoggingManager.Debug("timezone related details not fetched for ipaddress " + ipAddress);

                }
                return null;
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserTimeZoneByIp","TimeZoneHelperClass", ex.Message), ex);
                return null;
            }
        }

        public static TimeZoneDetailsModel GetGmtOffsetByTimeZone(string timeZoneName)
        {
            return GetDefaultTimeZones().FirstOrDefault((p) => p.TimeZone == timeZoneName);
        }

        public static List<TimeZoneDetailsModel> GetDefaultTimeZones()
        {
            var timeZoneDetails = new[]{
                new TimeZoneDetailsModel { CountryCode="AF", CountryName = "Afghanistan", TimeZone="Asia/Kabul", GMTOffset="+04:30", OffsetMinutes = 270},
                new TimeZoneDetailsModel { CountryCode="AL", CountryName = "Albania", TimeZone="Europe/Tirane", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="DZ", CountryName = "Algeria", TimeZone="Africa/Algiers", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="AS", CountryName = "American Samoa", TimeZone="Pacific/Pago_Pago", GMTOffset="-11:00", OffsetMinutes = -660},
                new TimeZoneDetailsModel { CountryCode="AD", CountryName = "Andorra", TimeZone="Europe/Andorra", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="AO", CountryName = "Angola", TimeZone="Africa/Luanda", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="AI", CountryName = "Anguilla", TimeZone="America/Anguilla", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="AQ", CountryName = "Antarctica", TimeZone="Antarctica/Casey", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="AQ", CountryName = "Antarctica", TimeZone="Antarctica/Davis", GMTOffset="+07:00", OffsetMinutes = 420},
                new TimeZoneDetailsModel { CountryCode="AQ", CountryName = "Antarctica", TimeZone="Antarctica/DumontDUrville", GMTOffset="+10:00", OffsetMinutes = 600},
                new TimeZoneDetailsModel { CountryCode="AQ", CountryName = "Antarctica", TimeZone="Antarctica/Mawson", GMTOffset="+05:00", OffsetMinutes = 300},
                new TimeZoneDetailsModel { CountryCode="AQ", CountryName = "Antarctica", TimeZone="Antarctica/McMurdo", GMTOffset="+13:00", OffsetMinutes = 780},
                new TimeZoneDetailsModel { CountryCode="AQ", CountryName = "Antarctica", TimeZone="Antarctica/Palmer", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="AQ", CountryName = "Antarctica", TimeZone="Antarctica/Rothera", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="AQ", CountryName = "Antarctica", TimeZone="Antarctica/Syowa", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="AQ", CountryName = "Antarctica", TimeZone="Antarctica/Troll", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="AQ", CountryName = "Antarctica", TimeZone="Antarctica/Vostok", GMTOffset="+06:00", OffsetMinutes = 360},
                new TimeZoneDetailsModel { CountryCode="AG", CountryName = "Antigua and Barbuda", TimeZone="America/Antigua", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="AR", CountryName = "Argentina", TimeZone="America/Argentina/Buenos_Aires", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="AR", CountryName = "Argentina", TimeZone="America/Argentina/Catamarca", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="AR", CountryName = "Argentina", TimeZone="America/Argentina/Cordoba", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="AR", CountryName = "Argentina", TimeZone="America/Argentina/Jujuy", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="AR", CountryName = "Argentina", TimeZone="America/Argentina/La_Rioja", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="AR", CountryName = "Argentina", TimeZone="America/Argentina/Mendoza", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="AR", CountryName = "Argentina", TimeZone="America/Argentina/Rio_Gallegos", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="AR", CountryName = "Argentina", TimeZone="America/Argentina/Salta", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="AR", CountryName = "Argentina", TimeZone="America/Argentina/San_Juan", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="AR", CountryName = "Argentina", TimeZone="America/Argentina/San_Luis", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="AR", CountryName = "Argentina", TimeZone="America/Argentina/Tucuman", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="AR", CountryName = "Argentina", TimeZone="America/Argentina/Ushuaia", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="AM", CountryName = "Armenia", TimeZone="Asia/Yerevan", GMTOffset="+04:00", OffsetMinutes = 240},
                new TimeZoneDetailsModel { CountryCode="AW", CountryName = "Aruba", TimeZone="America/Aruba", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="AU", CountryName = "Australia", TimeZone="Antarctica/Macquarie", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="AU", CountryName = "Australia", TimeZone="Australia/Adelaide", GMTOffset="+10:30", OffsetMinutes = 630},
                new TimeZoneDetailsModel { CountryCode="AU", CountryName = "Australia", TimeZone="Australia/Brisbane", GMTOffset="+10:00", OffsetMinutes = 600},
                new TimeZoneDetailsModel { CountryCode="AU", CountryName = "Australia", TimeZone="Australia/Broken_Hill", GMTOffset="+10:30", OffsetMinutes = 630},
                new TimeZoneDetailsModel { CountryCode="AU", CountryName = "Australia", TimeZone="Australia/Currie", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="AU", CountryName = "Australia", TimeZone="Australia/Darwin", GMTOffset="+09:30", OffsetMinutes = 570},
                new TimeZoneDetailsModel { CountryCode="AU", CountryName = "Australia", TimeZone="Australia/Eucla", GMTOffset="+08:45", OffsetMinutes = 525},
                new TimeZoneDetailsModel { CountryCode="AU", CountryName = "Australia", TimeZone="Australia/Hobart", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="AU", CountryName = "Australia", TimeZone="Australia/Lindeman", GMTOffset="+10:00", OffsetMinutes = 600},
                new TimeZoneDetailsModel { CountryCode="AU", CountryName = "Australia", TimeZone="Australia/Lord_Howe", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="AU", CountryName = "Australia", TimeZone="Australia/Melbourne", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="AU", CountryName = "Australia", TimeZone="Australia/Perth", GMTOffset="+08:00", OffsetMinutes = 480},
                new TimeZoneDetailsModel { CountryCode="AU", CountryName = "Australia", TimeZone="Australia/Sydney", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="AT", CountryName = "Austria", TimeZone="Europe/Vienna", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="AZ", CountryName = "Azerbaijan", TimeZone="Asia/Baku", GMTOffset="+04:00", OffsetMinutes = 240},
                new TimeZoneDetailsModel { CountryCode="BS", CountryName = "Bahamas", TimeZone="America/Nassau", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="BH", CountryName = "Bahrain", TimeZone="Asia/Bahrain", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="BD", CountryName = "Bangladesh", TimeZone="Asia/Dhaka", GMTOffset="+06:00", OffsetMinutes = 360},
                new TimeZoneDetailsModel { CountryCode="BB", CountryName = "Barbados", TimeZone="America/Barbados", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="BY", CountryName = "Belarus", TimeZone="Europe/Minsk", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="BE", CountryName = "Belgium", TimeZone="Europe/Brussels", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="BZ", CountryName = "Belize", TimeZone="America/Belize", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="BJ", CountryName = "Benin", TimeZone="Africa/Porto-Novo", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="BM", CountryName = "Bermuda", TimeZone="Atlantic/Bermuda", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="BT", CountryName = "Bhutan", TimeZone="Asia/Thimphu", GMTOffset="+06:00", OffsetMinutes = 360},
                new TimeZoneDetailsModel { CountryCode="BO", CountryName = "Bolivia, Plurinational State of", TimeZone="America/La_Paz", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="BQ", CountryName = "Bonaire, Sint Eustatius and Saba", TimeZone="America/Kralendijk", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="BA", CountryName = "Bosnia and Herzegovina", TimeZone="Europe/Sarajevo", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="BW", CountryName = "Botswana", TimeZone="Africa/Gaborone", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Araguaina", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Bahia", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Belem", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Boa_Vista", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Campo_Grande", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Cuiaba", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Eirunepe", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Fortaleza", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Maceio", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Manaus", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Noronha", GMTOffset="-02:00", OffsetMinutes = -120},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Porto_Velho", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Recife", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Rio_Branco", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Santarem", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="BR", CountryName = "Brazil", TimeZone="America/Sao_Paulo", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="IO", CountryName = "British Indian Ocean Territory", TimeZone="Indian/Chagos", GMTOffset="+06:00", OffsetMinutes = 360},
                new TimeZoneDetailsModel { CountryCode="BN", CountryName = "Brunei Darussalam", TimeZone="Asia/Brunei", GMTOffset="+08:00", OffsetMinutes = 480},
                new TimeZoneDetailsModel { CountryCode="BG", CountryName = "Bulgaria", TimeZone="Europe/Sofia", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="BF", CountryName = "Burkina Faso", TimeZone="Africa/Ouagadougou", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="BI", CountryName = "Burundi", TimeZone="Africa/Bujumbura", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="KH", CountryName = "Cambodia", TimeZone="Asia/Phnom_Penh", GMTOffset="+07:00", OffsetMinutes = 420},
                new TimeZoneDetailsModel { CountryCode="CM", CountryName = "Cameroon", TimeZone="Africa/Douala", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Atikokan", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Blanc-Sablon", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Cambridge_Bay", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Creston", GMTOffset="-07:00", OffsetMinutes = -420},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Dawson", GMTOffset="-07:00", OffsetMinutes = -420},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Dawson_Creek", GMTOffset="-07:00", OffsetMinutes = -420},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Edmonton", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Fort_Nelson", GMTOffset="-07:00", OffsetMinutes = -420},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Glace_Bay", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Goose_Bay", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Halifax", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Inuvik", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Iqaluit", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Moncton", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Nipigon", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Pangnirtung", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Rainy_River", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Rankin_Inlet", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Regina", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Resolute", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/St_Johns", GMTOffset="-02:30", OffsetMinutes = -150},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Swift_Current", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Thunder_Bay", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Toronto", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Vancouver", GMTOffset="-07:00", OffsetMinutes = -420},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Whitehorse", GMTOffset="-07:00", OffsetMinutes = -420},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Winnipeg", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="CA", CountryName = "Canada", TimeZone="America/Yellowknife", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="CV", CountryName = "Cape Verde", TimeZone="Atlantic/Cape_Verde", GMTOffset="-01:00", OffsetMinutes = -60},
                new TimeZoneDetailsModel { CountryCode="KY", CountryName = "Cayman Islands", TimeZone="America/Cayman", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="CF", CountryName = "Central African Republic", TimeZone="Africa/Bangui", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="TD", CountryName = "Chad", TimeZone="Africa/Ndjamena", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="CL", CountryName = "Chile", TimeZone="America/Punta_Arenas", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="CL", CountryName = "Chile", TimeZone="America/Santiago", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="CL", CountryName = "Chile", TimeZone="Pacific/Easter", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="CN", CountryName = "China", TimeZone="Asia/Shanghai", GMTOffset="+08:00", OffsetMinutes = 480},
                new TimeZoneDetailsModel { CountryCode="CN", CountryName = "China", TimeZone="Asia/Urumqi", GMTOffset="+06:00", OffsetMinutes = 360},
                new TimeZoneDetailsModel { CountryCode="CX", CountryName = "Christmas Island", TimeZone="Indian/Christmas", GMTOffset="+07:00", OffsetMinutes = 420},
                new TimeZoneDetailsModel { CountryCode="CC", CountryName = "Cocos (Keeling) Islands", TimeZone="Indian/Cocos", GMTOffset="+06:30", OffsetMinutes = 390},
                new TimeZoneDetailsModel { CountryCode="CO", CountryName = "Colombia", TimeZone="America/Bogota", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="KM", CountryName = "Comoros", TimeZone="Indian/Comoro", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="CG", CountryName = "Congo", TimeZone="Africa/Brazzaville", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="CD", CountryName = "Congo, the Democratic Republic of the", TimeZone="Africa/Kinshasa", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="CD", CountryName = "Congo, the Democratic Republic of the", TimeZone="Africa/Lubumbashi", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="CK", CountryName = "Cook Islands", TimeZone="Pacific/Rarotonga", GMTOffset="-10:00", OffsetMinutes = -600},
                new TimeZoneDetailsModel { CountryCode="CR", CountryName = "Costa Rica", TimeZone="America/Costa_Rica", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="HR", CountryName = "Croatia", TimeZone="Europe/Zagreb", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="CU", CountryName = "Cuba", TimeZone="America/Havana", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="CW", CountryName = "Curaçao", TimeZone="America/Curacao", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="CY", CountryName = "Cyprus", TimeZone="Asia/Famagusta", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="CY", CountryName = "Cyprus", TimeZone="Asia/Nicosia", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="CZ", CountryName = "Czech Republic", TimeZone="Europe/Prague", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="CI", CountryName = "Côte d'Ivoire", TimeZone="Africa/Abidjan", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="DK", CountryName = "Denmark", TimeZone="Europe/Copenhagen", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="DJ", CountryName = "Djibouti", TimeZone="Africa/Djibouti", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="DM", CountryName = "Dominica", TimeZone="America/Dominica", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="DO", CountryName = "Dominican Republic", TimeZone="America/Santo_Domingo", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="EC", CountryName = "Ecuador", TimeZone="America/Guayaquil", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="EC", CountryName = "Ecuador", TimeZone="Pacific/Galapagos", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="EG", CountryName = "Egypt", TimeZone="Africa/Cairo", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="SV", CountryName = "El Salvador", TimeZone="America/El_Salvador", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="GQ", CountryName = "Equatorial Guinea", TimeZone="Africa/Malabo", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="ER", CountryName = "Eritrea", TimeZone="Africa/Asmara", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="EE", CountryName = "Estonia", TimeZone="Europe/Tallinn", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="ET", CountryName = "Ethiopia", TimeZone="Africa/Addis_Ababa", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="FK", CountryName = "Falkland Islands (Malvinas)", TimeZone="Atlantic/Stanley", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="FO", CountryName = "Faroe Islands", TimeZone="Atlantic/Faroe", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="FJ", CountryName = "Fiji", TimeZone="Pacific/Fiji", GMTOffset="+12:00", OffsetMinutes = 720},
                new TimeZoneDetailsModel { CountryCode="FI", CountryName = "Finland", TimeZone="Europe/Helsinki", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="FR", CountryName = "France", TimeZone="Europe/Paris", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="GF", CountryName = "French Guiana", TimeZone="America/Cayenne", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="PF", CountryName = "French Polynesia", TimeZone="Pacific/Gambier", GMTOffset="-09:00", OffsetMinutes = -540},
                new TimeZoneDetailsModel { CountryCode="PF", CountryName = "French Polynesia", TimeZone="Pacific/Marquesas", GMTOffset="-09:30", OffsetMinutes = -570},
                new TimeZoneDetailsModel { CountryCode="PF", CountryName = "French Polynesia", TimeZone="Pacific/Tahiti", GMTOffset="-10:00", OffsetMinutes = -600},
                new TimeZoneDetailsModel { CountryCode="TF", CountryName = "French Southern Territories", TimeZone="Indian/Kerguelen", GMTOffset="+05:00", OffsetMinutes = 300},
                new TimeZoneDetailsModel { CountryCode="GA", CountryName = "Gabon", TimeZone="Africa/Libreville", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="GM", CountryName = "Gambia", TimeZone="Africa/Banjul", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="GE", CountryName = "Georgia", TimeZone="Asia/Tbilisi", GMTOffset="+04:00", OffsetMinutes = 240},
                new TimeZoneDetailsModel { CountryCode="DE", CountryName = "Germany", TimeZone="Europe/Berlin", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="DE", CountryName = "Germany", TimeZone="Europe/Busingen", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="GH", CountryName = "Ghana", TimeZone="Africa/Accra", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="GI", CountryName = "Gibraltar", TimeZone="Europe/Gibraltar", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="GR", CountryName = "Greece", TimeZone="Europe/Athens", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="GL", CountryName = "Greenland", TimeZone="America/Danmarkshavn", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="GL", CountryName = "Greenland", TimeZone="America/Nuuk", GMTOffset="-02:00", OffsetMinutes = -120},
                new TimeZoneDetailsModel { CountryCode="GL", CountryName = "Greenland", TimeZone="America/Scoresbysund", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="GL", CountryName = "Greenland", TimeZone="America/Thule", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="GD", CountryName = "Grenada", TimeZone="America/Grenada", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="GP", CountryName = "Guadeloupe", TimeZone="America/Guadeloupe", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="GU", CountryName = "Guam", TimeZone="Pacific/Guam", GMTOffset="+10:00", OffsetMinutes = 600},
                new TimeZoneDetailsModel { CountryCode="GT", CountryName = "Guatemala", TimeZone="America/Guatemala", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="GG", CountryName = "Guernsey", TimeZone="Europe/Guernsey", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="GN", CountryName = "Guinea", TimeZone="Africa/Conakry", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="GW", CountryName = "Guinea-Bissau", TimeZone="Africa/Bissau", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="GY", CountryName = "Guyana", TimeZone="America/Guyana", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="HT", CountryName = "Haiti", TimeZone="America/Port-au-Prince", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="VA", CountryName = "Holy See (Vatican City State)", TimeZone="Europe/Vatican", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="HN", CountryName = "Honduras", TimeZone="America/Tegucigalpa", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="HK", CountryName = "Hong Kong", TimeZone="Asia/Hong_Kong", GMTOffset="+08:00", OffsetMinutes = 480},
                new TimeZoneDetailsModel { CountryCode="HU", CountryName = "Hungary", TimeZone="Europe/Budapest", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="IS", CountryName = "Iceland", TimeZone="Atlantic/Reykjavik", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="IN", CountryName = "India", TimeZone="Asia/Kolkata", GMTOffset="+05:30", OffsetMinutes = 330},
                new TimeZoneDetailsModel { CountryCode="ID", CountryName = "Indonesia", TimeZone="Asia/Jakarta", GMTOffset="+07:00", OffsetMinutes = 420},
                new TimeZoneDetailsModel { CountryCode="ID", CountryName = "Indonesia", TimeZone="Asia/Jayapura", GMTOffset="+09:00", OffsetMinutes = 540},
                new TimeZoneDetailsModel { CountryCode="ID", CountryName = "Indonesia", TimeZone="Asia/Makassar", GMTOffset="+08:00", OffsetMinutes = 480},
                new TimeZoneDetailsModel { CountryCode="ID", CountryName = "Indonesia", TimeZone="Asia/Pontianak", GMTOffset="+07:00", OffsetMinutes = 420},
                new TimeZoneDetailsModel { CountryCode="IR", CountryName = "Iran, Islamic Republic of", TimeZone="Asia/Tehran", GMTOffset="+03:30", OffsetMinutes = 210},
                new TimeZoneDetailsModel { CountryCode="IQ", CountryName = "Iraq", TimeZone="Asia/Baghdad", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="IE", CountryName = "Ireland", TimeZone="Europe/Dublin", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="IM", CountryName = "Isle of Man", TimeZone="Europe/Isle_of_Man", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="IL", CountryName = "Israel", TimeZone="Asia/Jerusalem", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="IT", CountryName = "Italy", TimeZone="Europe/Rome", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="JM", CountryName = "Jamaica", TimeZone="America/Jamaica", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="JP", CountryName = "Japan", TimeZone="Asia/Tokyo", GMTOffset="+09:00", OffsetMinutes = 540},
                new TimeZoneDetailsModel { CountryCode="JE", CountryName = "Jersey", TimeZone="Europe/Jersey", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="JO", CountryName = "Jordan", TimeZone="Asia/Amman", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="KZ", CountryName = "Kazakhstan", TimeZone="Asia/Almaty", GMTOffset="+06:00", OffsetMinutes = 360},
                new TimeZoneDetailsModel { CountryCode="KZ", CountryName = "Kazakhstan", TimeZone="Asia/Aqtau", GMTOffset="+05:00", OffsetMinutes = 300},
                new TimeZoneDetailsModel { CountryCode="KZ", CountryName = "Kazakhstan", TimeZone="Asia/Aqtobe", GMTOffset="+05:00", OffsetMinutes = 300},
                new TimeZoneDetailsModel { CountryCode="KZ", CountryName = "Kazakhstan", TimeZone="Asia/Atyrau", GMTOffset="+05:00", OffsetMinutes = 300},
                new TimeZoneDetailsModel { CountryCode="KZ", CountryName = "Kazakhstan", TimeZone="Asia/Oral", GMTOffset="+05:00", OffsetMinutes = 300},
                new TimeZoneDetailsModel { CountryCode="KZ", CountryName = "Kazakhstan", TimeZone="Asia/Qostanay", GMTOffset="+06:00", OffsetMinutes = 360},
                new TimeZoneDetailsModel { CountryCode="KZ", CountryName = "Kazakhstan", TimeZone="Asia/Qyzylorda", GMTOffset="+05:00", OffsetMinutes = 300},
                new TimeZoneDetailsModel { CountryCode="KE", CountryName = "Kenya", TimeZone="Africa/Nairobi", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="KI", CountryName = "Kiribati", TimeZone="Pacific/Enderbury", GMTOffset="+13:00", OffsetMinutes = 780},
                new TimeZoneDetailsModel { CountryCode="KI", CountryName = "Kiribati", TimeZone="Pacific/Kiritimati", GMTOffset="+14:00", OffsetMinutes = 840},
                new TimeZoneDetailsModel { CountryCode="KI", CountryName = "Kiribati", TimeZone="Pacific/Tarawa", GMTOffset="+12:00", OffsetMinutes = 720},
                new TimeZoneDetailsModel { CountryCode="KP", CountryName = "Korea, Democratic People's Republic of", TimeZone="Asia/Pyongyang", GMTOffset="+09:00", OffsetMinutes = 540},
                new TimeZoneDetailsModel { CountryCode="KR", CountryName = "Korea, Republic of", TimeZone="Asia/Seoul", GMTOffset="+09:00", OffsetMinutes = 540},
                new TimeZoneDetailsModel { CountryCode="KW", CountryName = "Kuwait", TimeZone="Asia/Kuwait", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="KG", CountryName = "Kyrgyzstan", TimeZone="Asia/Bishkek", GMTOffset="+06:00", OffsetMinutes = 360},
                new TimeZoneDetailsModel { CountryCode="LA", CountryName = "Lao People's Democratic Republic", TimeZone="Asia/Vientiane", GMTOffset="+07:00", OffsetMinutes = 420},
                new TimeZoneDetailsModel { CountryCode="LV", CountryName = "Latvia", TimeZone="Europe/Riga", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="LB", CountryName = "Lebanon", TimeZone="Asia/Beirut", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="LS", CountryName = "Lesotho", TimeZone="Africa/Maseru", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="LR", CountryName = "Liberia", TimeZone="Africa/Monrovia", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="LY", CountryName = "Libya", TimeZone="Africa/Tripoli", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="LI", CountryName = "Liechtenstein", TimeZone="Europe/Vaduz", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="LT", CountryName = "Lithuania", TimeZone="Europe/Vilnius", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="LU", CountryName = "Luxembourg", TimeZone="Europe/Luxembourg", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="MO", CountryName = "Macao", TimeZone="Asia/Macau", GMTOffset="+08:00", OffsetMinutes = 480},
                new TimeZoneDetailsModel { CountryCode="MK", CountryName = "Macedonia, the Former Yugoslav Republic of", TimeZone="Europe/Skopje", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="MG", CountryName = "Madagascar", TimeZone="Indian/Antananarivo", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="MW", CountryName = "Malawi", TimeZone="Africa/Blantyre", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="MY", CountryName = "Malaysia", TimeZone="Asia/Kuala_Lumpur", GMTOffset="+08:00", OffsetMinutes = 480},
                new TimeZoneDetailsModel { CountryCode="MY", CountryName = "Malaysia", TimeZone="Asia/Kuching", GMTOffset="+08:00", OffsetMinutes = 480},
                new TimeZoneDetailsModel { CountryCode="MV", CountryName = "Maldives", TimeZone="Indian/Maldives", GMTOffset="+05:00", OffsetMinutes = 300},
                new TimeZoneDetailsModel { CountryCode="ML", CountryName = "Mali", TimeZone="Africa/Bamako", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="MT", CountryName = "Malta", TimeZone="Europe/Malta", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="MH", CountryName = "Marshall Islands", TimeZone="Pacific/Kwajalein", GMTOffset="+12:00", OffsetMinutes = 720},
                new TimeZoneDetailsModel { CountryCode="MH", CountryName = "Marshall Islands", TimeZone="Pacific/Majuro", GMTOffset="+12:00", OffsetMinutes = 720},
                new TimeZoneDetailsModel { CountryCode="MQ", CountryName = "Martinique", TimeZone="America/Martinique", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="MR", CountryName = "Mauritania", TimeZone="Africa/Nouakchott", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="MU", CountryName = "Mauritius", TimeZone="Indian/Mauritius", GMTOffset="+04:00", OffsetMinutes = 240},
                new TimeZoneDetailsModel { CountryCode="YT", CountryName = "Mayotte", TimeZone="Indian/Mayotte", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="MX", CountryName = "Mexico", TimeZone="America/Bahia_Banderas", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="MX", CountryName = "Mexico", TimeZone="America/Cancun", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="MX", CountryName = "Mexico", TimeZone="America/Chihuahua", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="MX", CountryName = "Mexico", TimeZone="America/Hermosillo", GMTOffset="-07:00", OffsetMinutes = -420},
                new TimeZoneDetailsModel { CountryCode="MX", CountryName = "Mexico", TimeZone="America/Matamoros", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="MX", CountryName = "Mexico", TimeZone="America/Mazatlan", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="MX", CountryName = "Mexico", TimeZone="America/Merida", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="MX", CountryName = "Mexico", TimeZone="America/Mexico_City", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="MX", CountryName = "Mexico", TimeZone="America/Monterrey", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="MX", CountryName = "Mexico", TimeZone="America/Ojinaga", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="MX", CountryName = "Mexico", TimeZone="America/Tijuana", GMTOffset="-07:00", OffsetMinutes = -420},
                new TimeZoneDetailsModel { CountryCode="FM", CountryName = "Micronesia, Federated States of", TimeZone="Pacific/Chuuk", GMTOffset="+10:00", OffsetMinutes = 600},
                new TimeZoneDetailsModel { CountryCode="FM", CountryName = "Micronesia, Federated States of", TimeZone="Pacific/Kosrae", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="FM", CountryName = "Micronesia, Federated States of", TimeZone="Pacific/Pohnpei", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="MD", CountryName = "Moldova, Republic of", TimeZone="Europe/Chisinau", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="MC", CountryName = "Monaco", TimeZone="Europe/Monaco", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="MN", CountryName = "Mongolia", TimeZone="Asia/Choibalsan", GMTOffset="+08:00", OffsetMinutes = 480},
                new TimeZoneDetailsModel { CountryCode="MN", CountryName = "Mongolia", TimeZone="Asia/Hovd", GMTOffset="+07:00", OffsetMinutes = 420},
                new TimeZoneDetailsModel { CountryCode="MN", CountryName = "Mongolia", TimeZone="Asia/Ulaanbaatar", GMTOffset="+08:00", OffsetMinutes = 480},
                new TimeZoneDetailsModel { CountryCode="ME", CountryName = "Montenegro", TimeZone="Europe/Podgorica", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="MS", CountryName = "Montserrat", TimeZone="America/Montserrat", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="MA", CountryName = "Morocco", TimeZone="Africa/Casablanca", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="MZ", CountryName = "Mozambique", TimeZone="Africa/Maputo", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="MM", CountryName = "Myanmar", TimeZone="Asia/Yangon", GMTOffset="+06:30", OffsetMinutes = 390},
                new TimeZoneDetailsModel { CountryCode="NA", CountryName = "Namibia", TimeZone="Africa/Windhoek", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="NR", CountryName = "Nauru", TimeZone="Pacific/Nauru", GMTOffset="+12:00", OffsetMinutes = 720},
                new TimeZoneDetailsModel { CountryCode="NP", CountryName = "Nepal", TimeZone="Asia/Kathmandu", GMTOffset="+05:45", OffsetMinutes = 345},
                new TimeZoneDetailsModel { CountryCode="NL", CountryName = "Netherlands", TimeZone="Europe/Amsterdam", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="NC", CountryName = "New Caledonia", TimeZone="Pacific/Noumea", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="NZ", CountryName = "New Zealand", TimeZone="Pacific/Auckland", GMTOffset="+13:00", OffsetMinutes = 780},
                new TimeZoneDetailsModel { CountryCode="NZ", CountryName = "New Zealand", TimeZone="Pacific/Chatham", GMTOffset="+13:45", OffsetMinutes = 825},
                new TimeZoneDetailsModel { CountryCode="NI", CountryName = "Nicaragua", TimeZone="America/Managua", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="NE", CountryName = "Niger", TimeZone="Africa/Niamey", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="NG", CountryName = "Nigeria", TimeZone="Africa/Lagos", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="NU", CountryName = "Niue", TimeZone="Pacific/Niue", GMTOffset="-11:00", OffsetMinutes = -660},
                new TimeZoneDetailsModel { CountryCode="NF", CountryName = "Norfolk Island", TimeZone="Pacific/Norfolk", GMTOffset="+12:00", OffsetMinutes = 720},
                new TimeZoneDetailsModel { CountryCode="MP", CountryName = "Northern Mariana Islands", TimeZone="Pacific/Saipan", GMTOffset="+10:00", OffsetMinutes = 600},
                new TimeZoneDetailsModel { CountryCode="NO", CountryName = "Norway", TimeZone="Europe/Oslo", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="OM", CountryName = "Oman", TimeZone="Asia/Muscat", GMTOffset="+04:00", OffsetMinutes = 240},
                new TimeZoneDetailsModel { CountryCode="PK", CountryName = "Pakistan", TimeZone="Asia/Karachi", GMTOffset="+05:00", OffsetMinutes = 300},
                new TimeZoneDetailsModel { CountryCode="PW", CountryName = "Palau", TimeZone="Pacific/Palau", GMTOffset="+09:00", OffsetMinutes = 540},
                new TimeZoneDetailsModel { CountryCode="PS", CountryName = "Palestine, State of", TimeZone="Asia/Gaza", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="PS", CountryName = "Palestine, State of", TimeZone="Asia/Hebron", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="PA", CountryName = "Panama", TimeZone="America/Panama", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="PG", CountryName = "Papua New Guinea", TimeZone="Pacific/Bougainville", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="PG", CountryName = "Papua New Guinea", TimeZone="Pacific/Port_Moresby", GMTOffset="+10:00", OffsetMinutes = 600},
                new TimeZoneDetailsModel { CountryCode="PY", CountryName = "Paraguay", TimeZone="America/Asuncion", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="PE", CountryName = "Peru", TimeZone="America/Lima", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="PH", CountryName = "Philippines", TimeZone="Asia/Manila", GMTOffset="+08:00", OffsetMinutes = 480},
                new TimeZoneDetailsModel { CountryCode="PN", CountryName = "Pitcairn", TimeZone="Pacific/Pitcairn", GMTOffset="-08:00", OffsetMinutes = -480},
                new TimeZoneDetailsModel { CountryCode="PL", CountryName = "Poland", TimeZone="Europe/Warsaw", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="PT", CountryName = "Portugal", TimeZone="Atlantic/Azores", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="PT", CountryName = "Portugal", TimeZone="Atlantic/Madeira", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="PT", CountryName = "Portugal", TimeZone="Europe/Lisbon", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="PR", CountryName = "Puerto Rico", TimeZone="America/Puerto_Rico", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="QA", CountryName = "Qatar", TimeZone="Asia/Qatar", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="RO", CountryName = "Romania", TimeZone="Europe/Bucharest", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Anadyr", GMTOffset="+12:00", OffsetMinutes = 720},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Barnaul", GMTOffset="+07:00", OffsetMinutes = 420},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Chita", GMTOffset="+09:00", OffsetMinutes = 540},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Irkutsk", GMTOffset="+08:00", OffsetMinutes = 480},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Kamchatka", GMTOffset="+12:00", OffsetMinutes = 720},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Khandyga", GMTOffset="+09:00", OffsetMinutes = 540},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Krasnoyarsk", GMTOffset="+07:00", OffsetMinutes = 420},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Magadan", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Novokuznetsk", GMTOffset="+07:00", OffsetMinutes = 420},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Novosibirsk", GMTOffset="+07:00", OffsetMinutes = 420},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Omsk", GMTOffset="+06:00", OffsetMinutes = 360},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Sakhalin", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Srednekolymsk", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Tomsk", GMTOffset="+07:00", OffsetMinutes = 420},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Ust-Nera", GMTOffset="+10:00", OffsetMinutes = 600},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Vladivostok", GMTOffset="+10:00", OffsetMinutes = 600},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Yakutsk", GMTOffset="+09:00", OffsetMinutes = 540},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Asia/Yekaterinburg", GMTOffset="+05:00", OffsetMinutes = 300},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Europe/Astrakhan", GMTOffset="+04:00", OffsetMinutes = 240},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Europe/Kaliningrad", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Europe/Kirov", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Europe/Moscow", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Europe/Samara", GMTOffset="+04:00", OffsetMinutes = 240},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Europe/Saratov", GMTOffset="+04:00", OffsetMinutes = 240},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Europe/Ulyanovsk", GMTOffset="+04:00", OffsetMinutes = 240},
                new TimeZoneDetailsModel { CountryCode="RU", CountryName = "Russian Federation", TimeZone="Europe/Volgograd", GMTOffset="+04:00", OffsetMinutes = 240},
                new TimeZoneDetailsModel { CountryCode="RW", CountryName = "Rwanda", TimeZone="Africa/Kigali", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="RE", CountryName = "Réunion", TimeZone="Indian/Reunion", GMTOffset="+04:00", OffsetMinutes = 240},
                new TimeZoneDetailsModel { CountryCode="BL", CountryName = "Saint Barthélemy", TimeZone="America/St_Barthelemy", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="SH", CountryName = "Saint Helena, Ascension and Tristan da Cunha", TimeZone="Atlantic/St_Helena", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="KN", CountryName = "Saint Kitts and Nevis", TimeZone="America/St_Kitts", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="LC", CountryName = "Saint Lucia", TimeZone="America/St_Lucia", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="MF", CountryName = "Saint Martin (French part)", TimeZone="America/Marigot", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="PM", CountryName = "Saint Pierre and Miquelon", TimeZone="America/Miquelon", GMTOffset="-02:00", OffsetMinutes = -120},
                new TimeZoneDetailsModel { CountryCode="VC", CountryName = "Saint Vincent and the Grenadines", TimeZone="America/St_Vincent", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="WS", CountryName = "Samoa", TimeZone="Pacific/Apia", GMTOffset="+14:00", OffsetMinutes = 840},
                new TimeZoneDetailsModel { CountryCode="SM", CountryName = "San Marino", TimeZone="Europe/San_Marino", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="ST", CountryName = "Sao Tome and Principe", TimeZone="Africa/Sao_Tome", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="SA", CountryName = "Saudi Arabia", TimeZone="Asia/Riyadh", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="SN", CountryName = "Senegal", TimeZone="Africa/Dakar", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="RS", CountryName = "Serbia", TimeZone="Europe/Belgrade", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="SC", CountryName = "Seychelles", TimeZone="Indian/Mahe", GMTOffset="+04:00", OffsetMinutes = 240},
                new TimeZoneDetailsModel { CountryCode="SL", CountryName = "Sierra Leone", TimeZone="Africa/Freetown", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="SG", CountryName = "Singapore", TimeZone="Asia/Singapore", GMTOffset="+08:00", OffsetMinutes = 480},
                new TimeZoneDetailsModel { CountryCode="SX", CountryName = "Sint Maarten (Dutch part)", TimeZone="America/Lower_Princes", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="SK", CountryName = "Slovakia", TimeZone="Europe/Bratislava", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="SI", CountryName = "Slovenia", TimeZone="Europe/Ljubljana", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="SB", CountryName = "Solomon Islands", TimeZone="Pacific/Guadalcanal", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="SO", CountryName = "Somalia", TimeZone="Africa/Mogadishu", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="ZA", CountryName = "South Africa", TimeZone="Africa/Johannesburg", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="GS", CountryName = "South Georgia and the South Sandwich Islands", TimeZone="Atlantic/South_Georgia", GMTOffset="-02:00", OffsetMinutes = -120},
                new TimeZoneDetailsModel { CountryCode="SS", CountryName = "South Sudan", TimeZone="Africa/Juba", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="ES", CountryName = "Spain", TimeZone="Africa/Ceuta", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="ES", CountryName = "Spain", TimeZone="Atlantic/Canary", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="ES", CountryName = "Spain", TimeZone="Europe/Madrid", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="LK", CountryName = "Sri Lanka", TimeZone="Asia/Colombo", GMTOffset="+05:30", OffsetMinutes = 330},
                new TimeZoneDetailsModel { CountryCode="SD", CountryName = "Sudan", TimeZone="Africa/Khartoum", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="SR", CountryName = "Suriname", TimeZone="America/Paramaribo", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="SJ", CountryName = "Svalbard and Jan Mayen", TimeZone="Arctic/Longyearbyen", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="SZ", CountryName = "Swaziland", TimeZone="Africa/Mbabane", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="SE", CountryName = "Sweden", TimeZone="Europe/Stockholm", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="CH", CountryName = "Switzerland", TimeZone="Europe/Zurich", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="SY", CountryName = "Syrian Arab Republic", TimeZone="Asia/Damascus", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="TW", CountryName = "Taiwan, Province of China", TimeZone="Asia/Taipei", GMTOffset="+08:00", OffsetMinutes = 480},
                new TimeZoneDetailsModel { CountryCode="TJ", CountryName = "Tajikistan", TimeZone="Asia/Dushanbe", GMTOffset="+05:00", OffsetMinutes = 300},
                new TimeZoneDetailsModel { CountryCode="TZ", CountryName = "Tanzania, United Republic of", TimeZone="Africa/Dar_es_Salaam", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="TH", CountryName = "Thailand", TimeZone="Asia/Bangkok", GMTOffset="+07:00", OffsetMinutes = 420},
                new TimeZoneDetailsModel { CountryCode="TL", CountryName = "Timor-Leste", TimeZone="Asia/Dili", GMTOffset="+09:00", OffsetMinutes = 540},
                new TimeZoneDetailsModel { CountryCode="TG", CountryName = "Togo", TimeZone="Africa/Lome", GMTOffset="+00:00", OffsetMinutes = 0},
                new TimeZoneDetailsModel { CountryCode="TK", CountryName = "Tokelau", TimeZone="Pacific/Fakaofo", GMTOffset="+13:00", OffsetMinutes = 780},
                new TimeZoneDetailsModel { CountryCode="TO", CountryName = "Tonga", TimeZone="Pacific/Tongatapu", GMTOffset="+13:00", OffsetMinutes = 780},
                new TimeZoneDetailsModel { CountryCode="TT", CountryName = "Trinidad and Tobago", TimeZone="America/Port_of_Spain", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="TN", CountryName = "Tunisia", TimeZone="Africa/Tunis", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="TR", CountryName = "Turkey", TimeZone="Europe/Istanbul", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="TM", CountryName = "Turkmenistan", TimeZone="Asia/Ashgabat", GMTOffset="+05:00", OffsetMinutes = 300},
                new TimeZoneDetailsModel { CountryCode="TC", CountryName = "Turks and Caicos Islands", TimeZone="America/Grand_Turk", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="TV", CountryName = "Tuvalu", TimeZone="Pacific/Funafuti", GMTOffset="+12:00", OffsetMinutes = 720},
                new TimeZoneDetailsModel { CountryCode="UG", CountryName = "Uganda", TimeZone="Africa/Kampala", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="UA", CountryName = "Ukraine", TimeZone="Europe/Kiev", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="UA", CountryName = "Ukraine", TimeZone="Europe/Simferopol", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="UA", CountryName = "Ukraine", TimeZone="Europe/Uzhgorod", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="UA", CountryName = "Ukraine", TimeZone="Europe/Zaporozhye", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="AE", CountryName = "United Arab Emirates", TimeZone="Asia/Dubai", GMTOffset="+04:00", OffsetMinutes = 240},
                new TimeZoneDetailsModel { CountryCode="GB", CountryName = "United Kingdom", TimeZone="Europe/London", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Adak", GMTOffset="-09:00", OffsetMinutes = -540},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Anchorage", GMTOffset="-08:00", OffsetMinutes = -480},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Boise", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Chicago", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Denver", GMTOffset="-06:00", OffsetMinutes = -360},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Detroit", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Indiana/Indianapolis", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Indiana/Knox", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Indiana/Marengo", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Indiana/Petersburg", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Indiana/Tell_City", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Indiana/Vevay", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Indiana/Vincennes", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Indiana/Winamac", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Juneau", GMTOffset="-08:00", OffsetMinutes = -480},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Kentucky/Louisville", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Kentucky/Monticello", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Los_Angeles", GMTOffset="-07:00", OffsetMinutes = -420},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Menominee", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Metlakatla", GMTOffset="-08:00", OffsetMinutes = -480},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/New_York", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Nome", GMTOffset="-08:00", OffsetMinutes = -480},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/North_Dakota/Beulah", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/North_Dakota/Center", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/North_Dakota/New_Salem", GMTOffset="-05:00", OffsetMinutes = -300},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Phoenix", GMTOffset="-07:00", OffsetMinutes = -420},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Sitka", GMTOffset="-08:00", OffsetMinutes = -480},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="America/Yakutat", GMTOffset="-08:00", OffsetMinutes = -480},
                new TimeZoneDetailsModel { CountryCode="US", CountryName = "United States", TimeZone="Pacific/Honolulu", GMTOffset="-10:00", OffsetMinutes = -600},
                new TimeZoneDetailsModel { CountryCode="UM", CountryName = "United States Minor Outlying Islands", TimeZone="Pacific/Midway", GMTOffset="-11:00", OffsetMinutes = -660},
                new TimeZoneDetailsModel { CountryCode="UM", CountryName = "United States Minor Outlying Islands", TimeZone="Pacific/Wake", GMTOffset="+12:00", OffsetMinutes = 720},
                new TimeZoneDetailsModel { CountryCode="UY", CountryName = "Uruguay", TimeZone="America/Montevideo", GMTOffset="-03:00", OffsetMinutes = -180},
                new TimeZoneDetailsModel { CountryCode="UZ", CountryName = "Uzbekistan", TimeZone="Asia/Samarkand", GMTOffset="+05:00", OffsetMinutes = 300},
                new TimeZoneDetailsModel { CountryCode="UZ", CountryName = "Uzbekistan", TimeZone="Asia/Tashkent", GMTOffset="+05:00", OffsetMinutes = 300},
                new TimeZoneDetailsModel { CountryCode="VU", CountryName = "Vanuatu", TimeZone="Pacific/Efate", GMTOffset="+11:00", OffsetMinutes = 660},
                new TimeZoneDetailsModel { CountryCode="VE", CountryName = "Venezuela, Bolivarian Republic of", TimeZone="America/Caracas", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="VN", CountryName = "Viet Nam", TimeZone="Asia/Ho_Chi_Minh", GMTOffset="+07:00", OffsetMinutes = 420},
                new TimeZoneDetailsModel { CountryCode="VG", CountryName = "Virgin Islands, British", TimeZone="America/Tortola", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="VI", CountryName = "Virgin Islands, U.S.", TimeZone="America/St_Thomas", GMTOffset="-04:00", OffsetMinutes = -240},
                new TimeZoneDetailsModel { CountryCode="WF", CountryName = "Wallis and Futuna", TimeZone="Pacific/Wallis", GMTOffset="+12:00", OffsetMinutes = 720},
                new TimeZoneDetailsModel { CountryCode="EH", CountryName = "Western Sahara", TimeZone="Africa/El_Aaiun", GMTOffset="+01:00", OffsetMinutes = 60},
                new TimeZoneDetailsModel { CountryCode="YE", CountryName = "Yemen", TimeZone="Asia/Aden", GMTOffset="+03:00", OffsetMinutes = 180},
                new TimeZoneDetailsModel { CountryCode="ZM", CountryName = "Zambia", TimeZone="Africa/Lusaka", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="ZW", CountryName = "Zimbabwe", TimeZone="Africa/Harare", GMTOffset="+02:00", OffsetMinutes = 120},
                new TimeZoneDetailsModel { CountryCode="AX", CountryName = "Åland Islands", TimeZone="Europe/Mariehamn", GMTOffset="+03:00", OffsetMinutes = 180}
            };
            List<TimeZoneDetailsModel> timeZones = timeZoneDetails.ToList();
            return timeZones;
        }
    }

    public class TimeZoneDetailsModel
    {
        public string CountryCode { get; set; }
        public string CountryName { get; set; }
        public string TimeZone { get; set; }
        public string GMTOffset { get; set; }
        public int OffsetMinutes { get; set; }
    }

    public class UserTimeZoneDetails
    {
        public string CountryCode { get; set; }
        public string CountryName { get; set; }
        public string TimeZone { get; set; }
        public string GMTOffset { get; set; }
        public int OffsetMinutes { get; set; }
        public DateTimeOffset? UserTimeOffset { get; set; }
    }
}
