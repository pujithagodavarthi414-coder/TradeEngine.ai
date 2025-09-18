using BusinessView.Common;
using BusinessView.DAL;
using System;
using System.Data.Entity;
using System.Linq;
using System.Web.Http;

namespace BusinessView.Api.Controllers.Api
{
    public class RoomTemperatureApiController : ApiController
    {
        [HttpPost]
        public void SaveRoomTemp(string temp)
        {
            using (var bviewEntities = new BViewEntities())
            {
                var roomTemperature = new RoomTemperature
                {
                    Temperature = Convert.ToInt32(temp),
                    Date = DateTime.Now
                };
                bviewEntities.RoomTemperatures.Add(roomTemperature);
                bviewEntities.SaveChanges();    
            }
        }

        [HttpGet]
        public string GetRoomTempStatus(DateTime date)
        {
            using (var bviewEntities = new BViewEntities())
            {
                double? avgTemp;
                string status;

                avgTemp = bviewEntities.RoomTemperatures.Where(x => DbFunctions.TruncateTime(x.Date) == date).ToList().Average(x => x.Temperature);

                if (avgTemp == null)
                    status = "#ead1dd";
                else if (avgTemp >= AppConstants.AvgRoomTemp)
                    status = "#ff141c";
                else
                    status = "#04fe02";

                return status;
            }
        }
    }
}
