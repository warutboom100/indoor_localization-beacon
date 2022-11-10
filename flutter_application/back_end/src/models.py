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
    __tablename__ = "posts"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    RSSI1: int = _sql.Column(_sql.Integer, index=True)
    RSSI2: int = _sql.Column(_sql.Integer, index=True)
    RSSI3: int = _sql.Column(_sql.Integer, index=True)
    RSSI4: int = _sql.Column(_sql.Integer, index=True)
    RSSI5: int = _sql.Column(_sql.Integer, index=True)
    owner_id = _sql.Column(_sql.String, _sql.ForeignKey("users.id"))
    date_created = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)
    date_last_updated = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)

    owner = _orm.relationship("User", back_populates="posts")


class User_pos(_database.Base):
    __tablename__ = "user_position"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    position_x: int = _sql.Column(_sql.Integer, index=True)
    position_y: int = _sql.Column(_sql.Integer, index=True)
    owner_id = _sql.Column(_sql.String, _sql.ForeignKey("users.id"))
    is_active = _sql.Column(_sql.Boolean, default=True)
    date_created = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)
    date_last_updated = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)

    