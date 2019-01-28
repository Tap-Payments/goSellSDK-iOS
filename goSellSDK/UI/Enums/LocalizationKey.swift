//
//  LocalizationKey.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal enum LocalizationKey: String {
	
	// MARK: Common
	
	case common_edit	= "common_edit"
	case common_cancel	= "common_cancel"
	
	// MARK: Pay Button Titles
	
    case btn_pay_title_generic 	= "btn_pay_title_generic"
    case btn_pay_title_amount	= "btn_pay_title_amount"
	
	// MARK: Save Button Title
	
	case btn_save_title			= "btn_save_title"
	case btn_save_action_title	= "btn_save_action_title"
	
	// MARK: Payment Option Group Titles
	
	case payment_options_group_title_recent = "payment_options_group_title_recent"
	case payment_options_group_title_others = "payment_options_group_title_others"
	
	// MARK: Card Input Fields Placeholders
	
	case card_input_card_number_placeholder 	= "card_input_card_number_placeholder"
	case card_input_expiration_date_placeholder	= "card_input_expiration_date_placeholder"
	case card_input_cvv_placeholder				= "card_input_cvv_placeholder"
	case card_input_cardholder_name_placeholder	= "card_input_cardholder_name_placeholder"
	case card_input_address_on_card_placeholder = "card_input_address_on_card_placeholder"
	
	// MARK: Save Card Placeholders
	
	case save_card_promotion_text = "save_card_promotion_text"
	
	// MARK: Screen Titles
	
	case currency_selection_screen_title	= "currency_selection_screen_title"
	case card_scanning_screen_title			= "card_scanning_screen_title"
	case payment_screen_title_payment		= "payment_screen_title_payment"
	case payment_screen_title_card_saving	= "payment_screen_title_card_saving"
	
	// MARK: Search Bar
	
	case search_bar_placeholder = "search_bar_placeholder"
	
	// MARK: OTP Screen
	
	case otp_guide_text		= "otp_guide_text"
	case btn_confirm_title	= "btn_confirm_title"
	case btn_resend_title	= "btn_resend_title"
	
	
	// MARK: -
	// MARK: Alert: Delete Card
	
	case alert_delete_card_title 			= "alert_delete_card_title"
	case alert_delete_card_message 			= "alert_delete_card_message"
	case alert_delete_card_btn_cancel_title	= "alert_delete_card_btn_cancel_title"
	case alert_delete_card_btn_delete_title = "alert_delete_card_btn_delete_title"
	
	// MARK: Alert: Extra Charges
	
	case alert_extra_charges_title 				= "alert_extra_charges_title"
	case alert_extra_charges_message 			= "alert_extra_charges_message"
	case alert_extra_charges_btn_cancel_title 	= "alert_extra_charges_btn_cancel_title"
	case alert_extra_charges_btn_confirm_title	= "alert_extra_charges_btn_confirm_title"
	
	// MARK: Alert: Cancel Payment (status undefined)
	
	case alert_cancel_payment_status_undefined_title				= "alert_cancel_payment_status_undefined_title"
	case alert_cancel_payment_status_undefined_message				= "alert_cancel_payment_status_undefined_message"
	case alert_cancel_payment_status_undefined_btn_no_title			= "alert_cancel_payment_status_undefined_btn_no_title"
	case alert_cancel_payment_status_undefined_btn_confirm_title	= "alert_cancel_payment_status_undefined_btn_confirm_title"
	
	// MARK: Alert: Cancel Payment (just cancel)
	
	case alert_cancel_payment_title 			= "alert_cancel_payment_title"
	case alert_cancel_payment_message 			= "alert_cancel_payment_message"
	case alert_cancel_payment_btn_no_title 		= "alert_cancel_payment_btn_no_title"
	case alert_cancel_payment_btn_confirm_title	= "alert_cancel_payment_btn_confirm_title"
	
	// MARK: Alert: Error
	
	case alert_error_1103_message 	= "alert_error_1103_message"
	case alert_error_1103_title 	= "alert_error_1103_title"
	
	case alert_error_1104_message 	= "alert_error_1104_message"
	case alert_error_1104_title 	= "alert_error_1104_title"
	
	case alert_error_1108_message 	= "alert_error_1108_message"
	case alert_error_1108_title 	= "alert_error_1108_title"
	
	case alert_error_1109_message 	= "alert_error_1109_message"
	case alert_error_1109_title 	= "alert_error_1109_title"
	
	case alert_error_1112_message 	= "alert_error_1112_message"
	case alert_error_1112_title 	= "alert_error_1112_title"
	
	case alert_error_1113_message 	= "alert_error_1113_message"
	case alert_error_1113_title 	= "alert_error_1113_title"
	
	case alert_error_1114_message 	= "alert_error_1114_message"
	case alert_error_1114_title 	= "alert_error_1114_title"
	
	case alert_error_1115_message 	= "alert_error_1115_message"
	case alert_error_1115_title 	= "alert_error_1115_title"
	
	case alert_error_1116_message 	= "alert_error_1116_message"
	case alert_error_1116_title 	= "alert_error_1116_title"
	
	case alert_error_1117_message 	= "alert_error_1117_message"
	case alert_error_1117_title 	= "alert_error_1117_title"
	
	case alert_error_1118_message 	= "alert_error_1118_message"
	case alert_error_1118_title 	= "alert_error_1118_title"
	
	case alert_error_1119_message 	= "alert_error_1119_message"
	case alert_error_1119_title 	= "alert_error_1119_title"
	
	case alert_error_1126_message 	= "alert_error_1126_message"
	case alert_error_1126_title 	= "alert_error_1126_title"
	
	case alert_error_1129_message 	= "alert_error_1129_message"
	case alert_error_1129_title 	= "alert_error_1129_title"
	
	case alert_error_1130_message 	= "alert_error_1130_message"
	case alert_error_1130_title 	= "alert_error_1130_title"
	
	case alert_error_1131_message 	= "alert_error_1131_message"
	case alert_error_1131_title 	= "alert_error_1131_title"
	
	case alert_error_1132_message 	= "alert_error_1132_message"
	case alert_error_1132_title 	= "alert_error_1132_title"
	
	case alert_error_1133_message 	= "alert_error_1133_message"
	case alert_error_1133_title 	= "alert_error_1133_title"
	
	case alert_error_1134_message 	= "alert_error_1134_message"
	case alert_error_1134_title 	= "alert_error_1134_title"
	
	case alert_error_1135_message 	= "alert_error_1135_message"
	case alert_error_1135_title 	= "alert_error_1135_title"
	
	case alert_error_1136_message 	= "alert_error_1136_message"
	case alert_error_1136_title 	= "alert_error_1136_title"
	
	case alert_error_1137_message 	= "alert_error_1137_message"
	case alert_error_1137_title 	= "alert_error_1137_title"
	
	case alert_error_1138_message 	= "alert_error_1138_message"
	case alert_error_1138_title 	= "alert_error_1138_title"
	
	case alert_error_1139_message 	= "alert_error_1139_message"
	case alert_error_1139_title 	= "alert_error_1139_title"
	
	case alert_error_1140_message 	= "alert_error_1140_message"
	case alert_error_1140_title 	= "alert_error_1140_title"
	
	case alert_error_1141_message 	= "alert_error_1141_message"
	case alert_error_1141_title 	= "alert_error_1141_title"
	
	case alert_error_1142_message 	= "alert_error_1142_message"
	case alert_error_1142_title 	= "alert_error_1142_title"
	
	case alert_error_1143_message 	= "alert_error_1143_message"
	case alert_error_1143_title 	= "alert_error_1143_title"
	
	case alert_error_1144_message 	= "alert_error_1144_message"
	case alert_error_1144_title 	= "alert_error_1144_title"
	
	case alert_error_1145_message 	= "alert_error_1145_message"
	case alert_error_1145_title 	= "alert_error_1145_title"
	
	case alert_error_1146_message 	= "alert_error_1146_message"
	case alert_error_1146_title 	= "alert_error_1146_title"
	
	case alert_error_1147_message 	= "alert_error_1147_message"
	case alert_error_1147_title 	= "alert_error_1147_title"
	
	case alert_error_1148_message 	= "alert_error_1148_message"
	case alert_error_1148_title 	= "alert_error_1148_title"
	
	case alert_error_1149_message 	= "alert_error_1149_message"
	case alert_error_1149_title 	= "alert_error_1149_title"
	
	case alert_error_1150_message 	= "alert_error_1150_message"
	case alert_error_1150_title 	= "alert_error_1150_title"
	
	case alert_error_1151_message 	= "alert_error_1151_message"
	case alert_error_1151_title 	= "alert_error_1151_title"
	
	case alert_error_1152_message 	= "alert_error_1152_message"
	case alert_error_1152_title 	= "alert_error_1152_title"
	
	case alert_error_1153_message 	= "alert_error_1153_message"
	case alert_error_1153_title 	= "alert_error_1153_title"
	
	case alert_error_2101_message 	= "alert_error_2101_message"
	case alert_error_2101_title 	= "alert_error_2101_title"
	
	case alert_error_2102_message 	= "alert_error_2102_message"
	case alert_error_2102_title 	= "alert_error_2102_title"
	
	case alert_error_2104_message 	= "alert_error_2104_message"
	case alert_error_2104_title 	= "alert_error_2104_title"
	
	case alert_error_2105_message 	= "alert_error_2105_message"
	case alert_error_2105_title 	= "alert_error_2105_title"
	
	case alert_error_2106_message 	= "alert_error_2106_message"
	case alert_error_2106_title 	= "alert_error_2106_title"
	
	case alert_error_3100_message 	= "alert_error_3100_message"
	case alert_error_3100_title 	= "alert_error_3100_title"
	
	case alert_error_8000_message 	= "alert_error_8000_message"
	case alert_error_8000_title 	= "alert_error_8000_title"
	
	case alert_error_8001_message 	= "alert_error_8001_message"
	case alert_error_8001_title 	= "alert_error_8001_title"
	
	case alert_error_8002_message 	= "alert_error_8002_message"
	case alert_error_8002_title 	= "alert_error_8002_title"
	
	case alert_error_8003_message 	= "alert_error_8003_message"
	case alert_error_8003_title 	= "alert_error_8003_title"
	
	case alert_error_8004_message 	= "alert_error_8004_message"
	case alert_error_8004_title 	= "alert_error_8004_title"
	
	case alert_error_8100_message 	= "alert_error_8100_message"
	case alert_error_8100_title 	= "alert_error_8100_title"
	
	case alert_error_8200_message 	= "alert_error_8200_message"
	case alert_error_8200_title 	= "alert_error_8200_title"
	
	case alert_error_9999_message	= "alert_error_9999_message"
	case alert_error_9999_title 	= "alert_error_9999_title"
	
	case alert_error_btn_retry_title	= "alert_error_btn_retry_title"
	case alert_error_btn_dismiss_title	= "alert_error_btn_dismiss_title"
	
	// MARK: Payment Statuses
	
	case payment_status_initiated	= "payment_status_initiated"
	case payment_status_in_progress	= "payment_status_in_progress"
	case payment_status_abandoned	= "payment_status_abandoned"
	case payment_status_cancelled	= "payment_status_cancelled"
	case payment_status_failed		= "payment_status_failed"
	case payment_status_declined	= "payment_status_declined"
	case payment_status_restricted	= "payment_status_restricted"
	case payment_status_captured	= "payment_status_captured"
	case payment_status_authorized	= "payment_status_authorized"
	case payment_status_unknown		= "payment_status_unknown"
	case payment_status_void		= "payment_status_void"
	
	case payment_status_alert_successful	= "payment_status_alert_successful"
	case payment_status_alert_failed		= "payment_status_alert_failed"
}
