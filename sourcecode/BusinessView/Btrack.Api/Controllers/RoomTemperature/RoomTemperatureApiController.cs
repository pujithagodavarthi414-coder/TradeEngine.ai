using System.Collections.Generic;
using System.Web.Http;
using Btrak.Models.RoomTemperature;
using Btrak.Services.RoomTemperature;
using BTrak.Api.Controllers.Api;

namespace BTrak.Api.Controllers.RoomTemperature
{
    public class RoomTemperatureApiController : AuthTokenApiController
    {
        private readonly RoomTemperatureService _roomTemperatureService;

        public RoomTemperatureApiController()
        {
            _roomTemperatureService = new RoomTemperatureService();
        }

        [HttpGet]
        [HttpOptions]
        [Route("RoomTemperature/RoomTemperatureApi/GetDailyRoomTemperature")]
        public List<RoomTemperatureModel> GetDailyRoomTemperature()
        {
            return _roomTemperatureService.GetDailyRoomTemperature();
        }

        [HttpPost]
        [HttpOptions]
        [Route("RoomTemperature/RoomTemperatureApi/SaveRoomTemp")]
        public void SaveRoomTemp(string temp)
        {
            _roomTemperatureService.SaveRoomTemp(temp);
        }
    }
}
