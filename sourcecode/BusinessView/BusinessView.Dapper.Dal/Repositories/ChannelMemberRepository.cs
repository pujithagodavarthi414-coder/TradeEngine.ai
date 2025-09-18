using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ChannelMemberRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ChannelMember table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ChannelMemberDbEntity aChannelMember)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aChannelMember.Id);
					 vParams.Add("@ChannelId",aChannelMember.ChannelId);
					 vParams.Add("@MemberUserId",aChannelMember.MemberUserId);
					 vParams.Add("@ActiveFrom",aChannelMember.ActiveFrom);
					 vParams.Add("@ActiveTo",aChannelMember.ActiveTo);
					 vParams.Add("@CreatedDateTime",aChannelMember.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aChannelMember.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aChannelMember.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aChannelMember.UpdatedByUserId);
					 vParams.Add("@IsActiveMember",aChannelMember.IsActiveMember);
					 int iResult = vConn.Execute("USP_ChannelMemberInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ChannelMember table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ChannelMemberDbEntity aChannelMember)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aChannelMember.Id);
					 vParams.Add("@ChannelId",aChannelMember.ChannelId);
					 vParams.Add("@MemberUserId",aChannelMember.MemberUserId);
					 vParams.Add("@ActiveFrom",aChannelMember.ActiveFrom);
					 vParams.Add("@ActiveTo",aChannelMember.ActiveTo);
					 vParams.Add("@CreatedDateTime",aChannelMember.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aChannelMember.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aChannelMember.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aChannelMember.UpdatedByUserId);
					 vParams.Add("@IsActiveMember",aChannelMember.IsActiveMember);
					 int iResult = vConn.Execute("USP_ChannelMemberUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ChannelMember table.
		/// </summary>
		public ChannelMemberDbEntity GetChannelMember(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ChannelMemberDbEntity>("USP_ChannelMemberSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ChannelMember table.
		/// </summary>
		 public IEnumerable<ChannelMemberDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ChannelMemberDbEntity>("USP_ChannelMemberSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ChannelMember table by a foreign key.
		/// </summary>
		public List<ChannelMemberDbEntity> SelectAllByChannelId(Guid channelId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@ChannelId",channelId);
				 return vConn.Query<ChannelMemberDbEntity>("USP_ChannelMemberSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
