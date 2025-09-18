using Btrak.Models.RoomTemperature;
using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class RoomTemperatureRepository
    {
        public List<RoomTemperatureModel> GetDailyRoomTemperature()
        {
            using (var vConn = OpenConnection())
            {
                return vConn.Query<RoomTemperatureModel>(StoredProcedureConstants.SpGetDailyTemperature, null, commandType: CommandType.StoredProcedure).ToList();
            }
        }
    }
}
