resource "aws_dynamodb_table" "crc_visitor_counter" {
    name           = "crc-visitor-counter"
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "PK"

    attribute {
        name = "PK"
        type = "S"
    }
}

