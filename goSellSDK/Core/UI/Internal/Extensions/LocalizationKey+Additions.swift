//
//  LocalizationKey.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	TapBundleLocalization.LocalizationKey

internal extension LocalizationKey {
	
	// MARK: - Internal -
	// MARK: Common
	
	internal static let common_edit		= LocalizationKey("common_edit")
	internal static let common_cancel	= LocalizationKey("common_cancel")
	
	// MARK: Pay Button Titles
	
    internal static let btn_pay_title_generic 	= LocalizationKey("btn_pay_title_generic")
    internal static let btn_pay_title_amount	= LocalizationKey("btn_pay_title_amount")
	
	// MARK: Save Button Title
	
	internal static let btn_save_title			= LocalizationKey("btn_save_title")
	internal static let btn_save_action_title	= LocalizationKey("btn_save_action_title")
	
	// MARK: Payment Option Group Titles
	
	internal static let payment_options_group_title_recent = LocalizationKey("payment_options_group_title_recent")
	internal static let payment_options_group_title_others = LocalizationKey("payment_options_group_title_others")
	
	// MARK: Card Input Fields Placeholders
	
	internal static let card_input_card_number_placeholder		= LocalizationKey("card_input_card_number_placeholder")
	internal static let card_input_expiration_date_placeholder	= LocalizationKey("card_input_expiration_date_placeholder")
	internal static let card_input_cvv_placeholder				= LocalizationKey("card_input_cvv_placeholder")
	internal static let card_input_cardholder_name_placeholder	= LocalizationKey("card_input_cardholder_name_placeholder")
	internal static let card_input_address_on_card_placeholder	= LocalizationKey("card_input_address_on_card_placeholder")
	
	// MARK: Save Card Placeholders
	
	internal static let save_card_promotion_text		= LocalizationKey("save_card_promotion_text")
	internal static let saved_cards_usage_description	= LocalizationKey("saved_cards_usage_description")
	
	// MARK: Screen Titles
	
	internal static let currency_selection_screen_title		= LocalizationKey("currency_selection_screen_title")
	internal static let card_scanning_screen_title			= LocalizationKey("card_scanning_screen_title")
	internal static let payment_screen_title_payment		= LocalizationKey("payment_screen_title_payment")
	internal static let payment_screen_title_card_saving	= LocalizationKey("payment_screen_title_card_saving")
	
	// MARK: Search Bar
	
	internal static let search_bar_placeholder = LocalizationKey("search_bar_placeholder")
	
	// MARK: OTP Screen
	
	internal static let otp_guide_text		= LocalizationKey("otp_guide_text")
	internal static let btn_confirm_title	= LocalizationKey("btn_confirm_title")
	internal static let btn_resend_title	= LocalizationKey("btn_resend_title")
	
	
	// MARK: -
	// MARK: Alert: Delete Card
	
	internal static let alert_delete_card_title 			= LocalizationKey("alert_delete_card_title")
	internal static let alert_delete_card_message 			= LocalizationKey("alert_delete_card_message")
	internal static let alert_delete_card_btn_cancel_title	= LocalizationKey("alert_delete_card_btn_cancel_title")
	internal static let alert_delete_card_btn_delete_title	= LocalizationKey("alert_delete_card_btn_delete_title")
	
	// MARK: Alert: Extra Charges
	
	internal static let alert_extra_charges_title 				= LocalizationKey("alert_extra_charges_title")
	internal static let alert_extra_charges_message 			= LocalizationKey("alert_extra_charges_message")
	internal static let alert_extra_charges_btn_cancel_title 	= LocalizationKey("alert_extra_charges_btn_cancel_title")
	internal static let alert_extra_charges_btn_confirm_title	= LocalizationKey("alert_extra_charges_btn_confirm_title")
	
	// MARK: Alert: Cancel Payment (status undefined)
	
	internal static let alert_cancel_payment_status_undefined_title				= LocalizationKey("alert_cancel_payment_status_undefined_title")
	internal static let alert_cancel_payment_status_undefined_message			= LocalizationKey("alert_cancel_payment_status_undefined_message")
	internal static let alert_cancel_payment_status_undefined_btn_no_title		= LocalizationKey("alert_cancel_payment_status_undefined_btn_no_title")
	internal static let alert_cancel_payment_status_undefined_btn_confirm_title	= LocalizationKey("alert_cancel_payment_status_undefined_btn_confirm_title")
	
	// MARK: Alert: Cancel Payment (just cancel)
	
	internal static let alert_cancel_payment_title 				= LocalizationKey("alert_cancel_payment_title")
	internal static let alert_cancel_payment_message 			= LocalizationKey("alert_cancel_payment_message")
	internal static let alert_cancel_payment_btn_no_title 		= LocalizationKey("alert_cancel_payment_btn_no_title")
	internal static let alert_cancel_payment_btn_confirm_title	= LocalizationKey("alert_cancel_payment_btn_confirm_title")
	
	// MARK: Alert: Error
	
	internal static let alert_error_1103_message 	= LocalizationKey("alert_error_1103_message")
	internal static let alert_error_1103_title 		= LocalizationKey("alert_error_1103_title")
	
	internal static let alert_error_1104_message 	= LocalizationKey("alert_error_1104_message")
	internal static let alert_error_1104_title 		= LocalizationKey("alert_error_1104_title")
	
	internal static let alert_error_1108_message 	= LocalizationKey("alert_error_1108_message")
	internal static let alert_error_1108_title 		= LocalizationKey("alert_error_1108_title")
	
	internal static let alert_error_1109_message 	= LocalizationKey("alert_error_1109_message")
	internal static let alert_error_1109_title 		= LocalizationKey("alert_error_1109_title")
	
	internal static let alert_error_1112_message 	= LocalizationKey("alert_error_1112_message")
	internal static let alert_error_1112_title 		= LocalizationKey("alert_error_1112_title")
	
	internal static let alert_error_1113_message 	= LocalizationKey("alert_error_1113_message")
	internal static let alert_error_1113_title 		= LocalizationKey("alert_error_1113_title")
	
	internal static let alert_error_1114_message 	= LocalizationKey("alert_error_1114_message")
	internal static let alert_error_1114_title 		= LocalizationKey("alert_error_1114_title")
	
	internal static let alert_error_1115_message 	= LocalizationKey("alert_error_1115_message")
	internal static let alert_error_1115_title 		= LocalizationKey("alert_error_1115_title")
	
	internal static let alert_error_1116_message 	= LocalizationKey("alert_error_1116_message")
	internal static let alert_error_1116_title 		= LocalizationKey("alert_error_1116_title")
	
	internal static let alert_error_1117_message 	= LocalizationKey("alert_error_1117_message")
	internal static let alert_error_1117_title 		= LocalizationKey("alert_error_1117_title")
	
	internal static let alert_error_1118_message 	= LocalizationKey("alert_error_1118_message")
	internal static let alert_error_1118_title 		= LocalizationKey("alert_error_1118_title")
	
	internal static let alert_error_1119_message 	= LocalizationKey("alert_error_1119_message")
	internal static let alert_error_1119_title 		= LocalizationKey("alert_error_1119_title")
	
	internal static let alert_error_1126_message 	= LocalizationKey("alert_error_1126_message")
	internal static let alert_error_1126_title 		= LocalizationKey("alert_error_1126_title")
	
	internal static let alert_error_1129_message 	= LocalizationKey("alert_error_1129_message")
	internal static let alert_error_1129_title 		= LocalizationKey("alert_error_1129_title")
	
	internal static let alert_error_1130_message 	= LocalizationKey("alert_error_1130_message")
	internal static let alert_error_1130_title 		= LocalizationKey("alert_error_1130_title")
	
	internal static let alert_error_1131_message 	= LocalizationKey("alert_error_1131_message")
	internal static let alert_error_1131_title 		= LocalizationKey("alert_error_1131_title")
	
	internal static let alert_error_1132_message 	= LocalizationKey("alert_error_1132_message")
	internal static let alert_error_1132_title 		= LocalizationKey("alert_error_1132_title")
	
	internal static let alert_error_1133_message 	= LocalizationKey("alert_error_1133_message")
	internal static let alert_error_1133_title 		= LocalizationKey("alert_error_1133_title")
	
	internal static let alert_error_1134_message 	= LocalizationKey("alert_error_1134_message")
	internal static let alert_error_1134_title 		= LocalizationKey("alert_error_1134_title")
	
	internal static let alert_error_1135_message 	= LocalizationKey("alert_error_1135_message")
	internal static let alert_error_1135_title 		= LocalizationKey("alert_error_1135_title")
	
	internal static let alert_error_1136_message 	= LocalizationKey("alert_error_1136_message")
	internal static let alert_error_1136_title 		= LocalizationKey("alert_error_1136_title")
	
	internal static let alert_error_1137_message 	= LocalizationKey("alert_error_1137_message")
	internal static let alert_error_1137_title 		= LocalizationKey("alert_error_1137_title")
	
	internal static let alert_error_1138_message 	= LocalizationKey("alert_error_1138_message")
	internal static let alert_error_1138_title 		= LocalizationKey("alert_error_1138_title")
	
	internal static let alert_error_1139_message 	= LocalizationKey("alert_error_1139_message")
	internal static let alert_error_1139_title 		= LocalizationKey("alert_error_1139_title")
	
	internal static let alert_error_1140_message 	= LocalizationKey("alert_error_1140_message")
	internal static let alert_error_1140_title 		= LocalizationKey("alert_error_1140_title")
	
	internal static let alert_error_1141_message 	= LocalizationKey("alert_error_1141_message")
	internal static let alert_error_1141_title 		= LocalizationKey("alert_error_1141_title")
	
	internal static let alert_error_1142_message 	= LocalizationKey("alert_error_1142_message")
	internal static let alert_error_1142_title 		= LocalizationKey("alert_error_1142_title")
	
	internal static let alert_error_1143_message 	= LocalizationKey("alert_error_1143_message")
	internal static let alert_error_1143_title 		= LocalizationKey("alert_error_1143_title")
	
	internal static let alert_error_1144_message 	= LocalizationKey("alert_error_1144_message")
	internal static let alert_error_1144_title 		= LocalizationKey("alert_error_1144_title")
	
	internal static let alert_error_1145_message 	= LocalizationKey("alert_error_1145_message")
	internal static let alert_error_1145_title 		= LocalizationKey("alert_error_1145_title")
	
	internal static let alert_error_1146_message 	= LocalizationKey("alert_error_1146_message")
	internal static let alert_error_1146_title 		= LocalizationKey("alert_error_1146_title")
	
	internal static let alert_error_1147_message 	= LocalizationKey("alert_error_1147_message")
	internal static let alert_error_1147_title 		= LocalizationKey("alert_error_1147_title")
	
	internal static let alert_error_1148_message 	= LocalizationKey("alert_error_1148_message")
	internal static let alert_error_1148_title 		= LocalizationKey("alert_error_1148_title")
	
	internal static let alert_error_1149_message 	= LocalizationKey("alert_error_1149_message")
	internal static let alert_error_1149_title 		= LocalizationKey("alert_error_1149_title")
	
	internal static let alert_error_1150_message 	= LocalizationKey("alert_error_1150_message")
	internal static let alert_error_1150_title 		= LocalizationKey("alert_error_1150_title")
	
	internal static let alert_error_1151_message 	= LocalizationKey("alert_error_1151_message")
	internal static let alert_error_1151_title 		= LocalizationKey("alert_error_1151_title")
	
	internal static let alert_error_1152_message 	= LocalizationKey("alert_error_1152_message")
	internal static let alert_error_1152_title 		= LocalizationKey("alert_error_1152_title")
	
	internal static let alert_error_1153_message 	= LocalizationKey("alert_error_1153_message")
	internal static let alert_error_1153_title 		= LocalizationKey("alert_error_1153_title")
	
	internal static let alert_error_2101_message 	= LocalizationKey("alert_error_2101_message")
	internal static let alert_error_2101_title 		= LocalizationKey("alert_error_2101_title")
	
	internal static let alert_error_2102_message 	= LocalizationKey("alert_error_2102_message")
	internal static let alert_error_2102_title 		= LocalizationKey("alert_error_2102_title")
	
	internal static let alert_error_2104_message 	= LocalizationKey("alert_error_2104_message")
	internal static let alert_error_2104_title 		= LocalizationKey("alert_error_2104_title")
	
	internal static let alert_error_2105_message 	= LocalizationKey("alert_error_2105_message")
	internal static let alert_error_2105_title 		= LocalizationKey("alert_error_2105_title")
	
	internal static let alert_error_2106_message 	= LocalizationKey("alert_error_2106_message")
	internal static let alert_error_2106_title 		= LocalizationKey("alert_error_2106_title")
	
	internal static let alert_error_3100_message 	= LocalizationKey("alert_error_3100_message")
	internal static let alert_error_3100_title 		= LocalizationKey("alert_error_3100_title")
	
	internal static let alert_error_8000_message 	= LocalizationKey("alert_error_8000_message")
	internal static let alert_error_8000_title 		= LocalizationKey("alert_error_8000_title")
	
	internal static let alert_error_8001_message 	= LocalizationKey("alert_error_8001_message")
	internal static let alert_error_8001_title 		= LocalizationKey("alert_error_8001_title")
	
	internal static let alert_error_8002_message 	= LocalizationKey("alert_error_8002_message")
	internal static let alert_error_8002_title 		= LocalizationKey("alert_error_8002_title")
	
	internal static let alert_error_8003_message 	= LocalizationKey("alert_error_8003_message")
	internal static let alert_error_8003_title 		= LocalizationKey("alert_error_8003_title")
	
	internal static let alert_error_8004_message 	= LocalizationKey("alert_error_8004_message")
	internal static let alert_error_8004_title 		= LocalizationKey("alert_error_8004_title")
	
	internal static let alert_error_8100_message 	= LocalizationKey("alert_error_8100_message")
	internal static let alert_error_8100_title 		= LocalizationKey("alert_error_8100_title")
	
	internal static let alert_error_8200_message 	= LocalizationKey("alert_error_8200_message")
	internal static let alert_error_8200_title 		= LocalizationKey("alert_error_8200_title")
	
	internal static let alert_error_8302_message	= LocalizationKey("alert_error_8302_message")
	internal static let alert_error_8302_title		= LocalizationKey("alert_error_8302_title")
	
	internal static let alert_error_8400_message	= LocalizationKey("alert_error_8400_message")
	internal static let alert_error_8400_title		= LocalizationKey("alert_error_8400_title")
	
	internal static let alert_error_8401_message	= LocalizationKey("alert_error_8401_message")
	internal static let alert_error_8401_title		= LocalizationKey("alert_error_8401_title")
	
	internal static let alert_error_8402_message	= LocalizationKey("alert_error_8402_message")
	internal static let alert_error_8402_title		= LocalizationKey("alert_error_8402_title")
	
	internal static let alert_error_8403_message	= LocalizationKey("alert_error_8403_message")
	internal static let alert_error_8403_title		= LocalizationKey("alert_error_8403_title")
	
	internal static let alert_error_9999_message	= LocalizationKey("alert_error_9999_message")
	internal static let alert_error_9999_title 		= LocalizationKey("alert_error_9999_title")
	
	internal static let alert_error_btn_retry_title		= LocalizationKey("alert_error_btn_retry_title")
	internal static let alert_error_btn_dismiss_title	= LocalizationKey("alert_error_btn_dismiss_title")
	internal static let alert_error_btn_report_title	= LocalizationKey("alert_error_btn_report_title")
	
	// MARK: Payment Statuses
	
	internal static let payment_status_initiated	= LocalizationKey("payment_status_initiated")
	internal static let payment_status_in_progress	= LocalizationKey("payment_status_in_progress")
	internal static let payment_status_abandoned	= LocalizationKey("payment_status_abandoned")
	internal static let payment_status_cancelled	= LocalizationKey("payment_status_cancelled")
	internal static let payment_status_failed		= LocalizationKey("payment_status_failed")
	internal static let payment_status_declined		= LocalizationKey("payment_status_declined")
	internal static let payment_status_restricted	= LocalizationKey("payment_status_restricted")
	internal static let payment_status_captured		= LocalizationKey("payment_status_captured")
	internal static let payment_status_authorized	= LocalizationKey("payment_status_authorized")
	internal static let payment_status_unknown		= LocalizationKey("payment_status_unknown")
	internal static let payment_status_void			= LocalizationKey("payment_status_void")
	
	internal static let payment_status_alert_successful	= LocalizationKey("payment_status_alert_successful")
	internal static let payment_status_alert_failed		= LocalizationKey("payment_status_alert_failed")
}
