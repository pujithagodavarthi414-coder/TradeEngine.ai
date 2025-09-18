using Btrak.Models.RoomTemperature;
using System.Collections.Generic;


namespace Btrak.Services.RoomTemperature
{
    public interface IRoomTemperatureService
    {
        List<RoomTemperatureModel> GetDailyRoomTemperature();
        void SaveRoomTemp(string temp);
    }
}