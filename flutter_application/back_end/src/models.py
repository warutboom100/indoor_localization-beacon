import datetime as _dt
from turtle import position
import sqlalchemy as _sql
import sqlalchemy.orm as _orm

import database as _database


class User(_database.Base):
    __tablename__ = "users"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    deviceID = _sql.Column(_sql.String, unique=True, index=True)
    is_active = _sql.Column(_sql.Boolean, default=True)
    posts = _orm.relationship("Post", back_populates="owner")


class Post(_database.Base):
    __tablename__ = "read_rssi"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    RSSI1: float = _sql.Column(_sql.Float, index=True)
    RSSI2: float = _sql.Column(_sql.Float, index=True)
    RSSI3: float = _sql.Column(_sql.Float, index=True)
    RSSI4: float = _sql.Column(_sql.Float, index=True)
    RSSI5: float = _sql.Column(_sql.Float, index=True)
    
    owner_id = _sql.Column(_sql.String, _sql.ForeignKey("users.id"))
    date_created = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)
    date_last_updated = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)

    owner = _orm.relationship("User", back_populates="posts")

class rssi(_database.Base):
    __tablename__ = "data_rssi"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    rssi1: float = _sql.Column(_sql.Float, index=True)
    rssi2: float = _sql.Column(_sql.Float, index=True)
    rssi3: float = _sql.Column(_sql.Float, index=True)
    rssi4: float = _sql.Column(_sql.Float, index=True)
    rssi5: float = _sql.Column(_sql.Float, index=True)
    owner_id = _sql.Column(_sql.String, _sql.ForeignKey("users.id"))
    is_active = _sql.Column(_sql.Boolean, default=True)
    date_created = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)
    date_last_updated = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)


class Post_dist(_database.Base):
    __tablename__ = "read_dist"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    DIST1: float = _sql.Column(_sql.Float, index=True)
    DIST2: float = _sql.Column(_sql.Float, index=True)
    DIST3: float = _sql.Column(_sql.Float, index=True)
    DIST4: float = _sql.Column(_sql.Float, index=True)
    DIST5: float = _sql.Column(_sql.Float, index=True)
    owner_id = _sql.Column(_sql.String, _sql.ForeignKey("users.id"))
    is_active = _sql.Column(_sql.Boolean, default=True)
    date_created = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)
    date_last_updated = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)

class dist(_database.Base):
    __tablename__ = "data_dist"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    dist1: float = _sql.Column(_sql.Float, index=True)
    dist2: float = _sql.Column(_sql.Float, index=True)
    dist3: float = _sql.Column(_sql.Float, index=True)
    dist4: float = _sql.Column(_sql.Float, index=True)
    dist5: float = _sql.Column(_sql.Float, index=True)
    owner_id = _sql.Column(_sql.String, _sql.ForeignKey("users.id"))
    is_active = _sql.Column(_sql.Boolean, default=True)
    date_created = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)
    date_last_updated = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)

class User_pos(_database.Base):
    __tablename__ = "user_position"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    position_x: float = _sql.Column(_sql.Float, index=True)
    position_y: float = _sql.Column(_sql.Float, index=True)
    owner_id = _sql.Column(_sql.String, _sql.ForeignKey("users.id"))
    is_active = _sql.Column(_sql.Boolean, default=True)
    date_created = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)
    date_last_updated = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)

class data_pos(_database.Base):
    __tablename__ = "data_position"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    x: float = _sql.Column(_sql.Float, index=True)
    y: float = _sql.Column(_sql.Float, index=True)
    owner_id = _sql.Column(_sql.String, _sql.ForeignKey("users.id"))
    is_active = _sql.Column(_sql.Boolean, default=True)
    date_created = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)
    date_last_updated = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)

class weight_rssi(_database.Base):
    __tablename__ = "weight_rssi"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    mean_rssi1: float = _sql.Column(_sql.Float, index=True)
    std_rssi1: float = _sql.Column(_sql.Float, index=True)
    mean_rssi2: float = _sql.Column(_sql.Float, index=True)
    std_rssi2: float = _sql.Column(_sql.Float, index=True)
    mean_rssi3: float = _sql.Column(_sql.Float, index=True)
    std_rssi3: float = _sql.Column(_sql.Float, index=True)
    mean_rssi4: float = _sql.Column(_sql.Float, index=True)
    std_rssi4: float = _sql.Column(_sql.Float, index=True)
    mean_rssi5: float = _sql.Column(_sql.Float, index=True)
    std_rssi5: float = _sql.Column(_sql.Float, index=True)
    owner_id = _sql.Column(_sql.String, _sql.ForeignKey("users.id"))
    is_active = _sql.Column(_sql.Boolean, default=True)
    date_created = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)
    date_last_updated = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)

class weight_position(_database.Base):
    __tablename__ = "weight_position"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    mean_pos_x: float = _sql.Column(_sql.Float, index=True)
    std_pos_x: float = _sql.Column(_sql.Float, index=True)
    mean_pos_y: float = _sql.Column(_sql.Float, index=True)
    std_pos_y: float = _sql.Column(_sql.Float, index=True)
    owner_id = _sql.Column(_sql.String, _sql.ForeignKey("users.id"))
    is_active = _sql.Column(_sql.Boolean, default=True)
    date_created = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)
    date_last_updated = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)

class weight_dist(_database.Base):
    __tablename__ = "weight_dist"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    mean_dist1: float = _sql.Column(_sql.Float, index=True)
    std_dist1: float = _sql.Column(_sql.Float, index=True)
    mean_dist2: float = _sql.Column(_sql.Float, index=True)
    std_dist2: float = _sql.Column(_sql.Float, index=True)
    mean_dist3: float = _sql.Column(_sql.Float, index=True)
    std_dist3: float = _sql.Column(_sql.Float, index=True)
    mean_dist4: float = _sql.Column(_sql.Float, index=True)
    std_dist4: float = _sql.Column(_sql.Float, index=True)
    mean_dist5: float = _sql.Column(_sql.Float, index=True)
    std_dist5: float = _sql.Column(_sql.Float, index=True)
    owner_id = _sql.Column(_sql.String, _sql.ForeignKey("users.id"))
    is_active = _sql.Column(_sql.Boolean, default=True)
    date_created = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)
    date_last_updated = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)