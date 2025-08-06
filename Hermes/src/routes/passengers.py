from flask import Blueprint, jsonify
import json
from src.extensions import db as pdb

passengers_bp = Blueprint('passengers', __name__)

@passengers_bp.route('/')
def get_passengers():
    """Получение списка пассажиров"""
    return jsonify([{"id": 2, "name": "Test Passenger"}])

@passengers_bp.route('/get_passengers_by_flight', methods=["GET"])
def get_passengers_by_flight():
    query = """
        SELECT 
            fb.pnr,
            CONCAT(pp.first_name, ' ', pp.last_name) as name,
            'ВЭ' as ps,
            'Э' as kl,
            'Э' as podkl,
            '1' as kr,
            'РЩН' as pn,
            'PB832492' as ticket,
            pp.passport_number as doc
        FROM 
            (SELECT 
                unnest(passenger_ids) AS passenger_id,
                pnr
            FROM flights.bookings 
            WHERE flight_id = 1) AS fb
        JOIN 
            passengers.passengers pp ON pp.passenger_id = fb.passenger_id;
            """
    return jsonify(pdb.fetch_all_json(query))