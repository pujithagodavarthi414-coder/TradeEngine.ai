using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ChannelRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Channel table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ChannelDbEntity aChannel)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aChannel.Id);
					 vParams.Add("@CompanyId",aChannel.CompanyId);
					 vParams.Add("@ChannelName",aChannel.ChannelName);
					 vParams.Add("@IsDeleted",aChannel.IsDeleted);
					 vParams.Add("@ChannelImage",aChannel.ChannelImage);
					 vParams.Add("@CreatedDateTime",aChannel.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aChannel.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aChannel.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aChannel.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ChannelInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Channel table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ChannelDbEntity aChannel)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aChannel.Id);
					 vParams.Add("@CompanyId",aChannel.CompanyId);
					 vParams.Add("@ChannelName",aChannel.ChannelName);
					 vParams.Add("@IsDeleted",aChannel.IsDeleted);
					 vParams.Add("@ChannelImage",aChannel.ChannelImage);
					 vParams.Add("@CreatedDateTime",aChannel.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aChannel.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aChannel.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aChannel.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_ChannelUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Channel table.
		/// </summary>
		public ChannelDbEntity GetChannel(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ChannelDbEntity>("USP_ChannelSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Channel table.
		/// </summary>
		 public IEnumerable<ChannelDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ChannelDbEntity>("USP_ChannelSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
