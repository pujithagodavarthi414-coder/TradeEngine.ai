
using Btrak.Models.RoomTemperature;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Btrak.Dapper.Dal.Repositories;

namespace Btrak.Services.RoomTemperature
{
    public class RoomTemperatureService : IRoomTemperatureService
    {
        private readonly RoomTemperatureRepository _roomTemperatureRepository; 

        public RoomTemperatureService()
        {
            _roomTemperatureRepository = new RoomTemperatureRepository();
        }

        public List<RoomTemperatureModel> GetDailyRoomTemperature()
        {
            var roomTemperatureModel = _roomTemperatureRepository.GetDailyRoomTemperature().Select(x => x).ToList();

            return roomTemperatureModel;
        }

        public void SaveRoomTemp(string temp)
        {
            RoomTemperatureDbEntity roomTemperatureDbEntity = new RoomTemperatureDbEntity
            {
                Id = Guid.NewGuid(),
                Date = DateTime.Now,
                Temperature = Convert.ToInt32(temp)
            };
            _roomTemperatureRepository.Insert(roomTemperatureDbEntity);
        }
    }
}
